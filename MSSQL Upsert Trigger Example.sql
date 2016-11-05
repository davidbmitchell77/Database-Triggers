CREATE TRIGGER AccountUpsertTrigger ON Accounts
INSTEAD OF INSERT
AS
SET NOCOUNT ON
DECLARE @Id VARCHAR(18)
DECLARE @CreatedDate DATETIME
DECLARE @CreatedBy VARCHAR(100)
DECLARE @LastModifiedDate DATETIME
DECLARE @LastModifiedBy VARCHAR(100)
DECLARE @Name VARCHAR(150)
DECLARE @BillingCity VARCHAR(100)
DECLARE @BillingState VARCHAR(100)
BEGIN
  DECLARE C1 CUROR FOR
  SELECT
  Id,
  CreatedDate,
  CreatedBy,
  LastModifiedDate,
  LastModifiedBy,
  Name,
  BillingCity,
  BillingState
  FROM inserted
  FOR READ ONLY
  OPEN C1
  FETCH C1 INTO
  @Id,
  @CreatedDate,
  @CreatedBy,
  @LastModifiedDate,
  @LastModifiedBy,
  @Name,
  @BillingCity,
  @BillingState
  WHILE @@FETCH_STATUS = 0
  BEGIN
    IF NOT EXISTS (SELECT TOP 1 Id FROM Accounts WHERE Id = @Id)
    BEGIN
      INSERT INTO Accounts (
        Id,
        CreatedDate,
        CreatedBy,
        LastModifiedDate,
        LastModifiedBy,
        Name,
        BillingCity,
        BillingState
      ) VALUES (
        @Id,
        @CreatedDate,
        @CreatedBy,
        @LastModifiedDate,
        @LastModifiedBy,
        @Name,
        @BillingCity,
        @BillingState
      )
    END
    FETCH NEXT FROM C1 INTO
    @Id,
    @CreatedDate,
    @CreatedBy,
    @LastModifiedDate,
    @LastModifiedBy,
    @Name,
    @BillingCity,
    @BillingState
  END
  CLOSE C1
  DEALLOCATE C1
  INSERT INTO Accounts SELECT * FROM inserted i WHERE NOT EXISTS (SELECT Id from Accounts a WHERE a.Id = i.Id)
END
GO

