USE [master]
GO
/****** Object:  Database [DoAnCuaBach]    Script Date: 11/10/2019 10:10:15 AM ******/
CREATE DATABASE [DoAnCuaBach]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DoAnCuaBach', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\DoAnCuaBach.mdf' , SIZE = 3136KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'DoAnCuaBach_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\DoAnCuaBach_log.ldf' , SIZE = 784KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [DoAnCuaBach] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DoAnCuaBach].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DoAnCuaBach] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [DoAnCuaBach] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [DoAnCuaBach] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [DoAnCuaBach] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [DoAnCuaBach] SET ARITHABORT OFF 
GO
ALTER DATABASE [DoAnCuaBach] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [DoAnCuaBach] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [DoAnCuaBach] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DoAnCuaBach] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [DoAnCuaBach] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DoAnCuaBach] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [DoAnCuaBach] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [DoAnCuaBach] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DoAnCuaBach] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [DoAnCuaBach] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DoAnCuaBach] SET  ENABLE_BROKER 
GO
ALTER DATABASE [DoAnCuaBach] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [DoAnCuaBach] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DoAnCuaBach] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DoAnCuaBach] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [DoAnCuaBach] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DoAnCuaBach] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [DoAnCuaBach] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [DoAnCuaBach] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [DoAnCuaBach] SET  MULTI_USER 
GO
ALTER DATABASE [DoAnCuaBach] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [DoAnCuaBach] SET DB_CHAINING OFF 
GO
ALTER DATABASE [DoAnCuaBach] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [DoAnCuaBach] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [DoAnCuaBach]
GO
/****** Object:  StoredProcedure [dbo].[USP_Export]    Script Date: 11/10/2019 10:10:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_Export]
@idBill	NVARCHAR(3)	
AS 
	BEGIN
		 
		SELECT f.name, bi.count FROM dbo.BillInfo AS bi, dbo.Food AS f WHERE bi.idFood = f.id AND bi.idBill IN (SELECT b.id FROM dbo.Bill AS b WHERE b.id = @idBill )			
	END

GO
/****** Object:  StoredProcedure [dbo].[USP_ExportBill]    Script Date: 11/10/2019 10:10:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_ExportBill]
@idBill	NVARCHAR(3)	
AS 
	BEGIN		 		
		SELECT totalPrice FROM dbo.Bill WHERE id = @idBill	
	END

GO
/****** Object:  StoredProcedure [dbo].[USP_ExportBillToReport]    Script Date: 11/10/2019 10:10:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[USP_ExportBillToReport]
@idBill	NVARCHAR(3)	
AS 
	BEGIN		 
		SELECT f.name, f.price, bi.count, bi.count * f.price AS TotalPrice 
		FROM dbo.BillInfo AS bi, dbo.Food AS f WHERE bi.idFood = f.id AND bi.idBill 
		IN (SELECT b.id FROM dbo.Bill AS b WHERE b.id = @idBill)				
	END

GO
/****** Object:  StoredProcedure [dbo].[USP_GetAccountByUserName]    Script Date: 11/10/2019 10:10:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_GetAccountByUserName]
@userName nvarchar (100)
AS
BEGIN
    SELECT * FROM  dbo.Account WHERE Username = @userName
END

GO
/****** Object:  StoredProcedure [dbo].[USP_GetListBillByDate]    Script Date: 11/10/2019 10:10:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_GetListBillByDate]
AS 
BEGIN
DECLARE @checkIn DATE
DECLARE @checkOut DATE 
	SELECT t.name AS [Tên bàn], b.totalPrice AS [Tổng tiền], DateCheckIn AS [Ngày vào], DateCheckOut AS [Ngày ra], discount AS [Giảm giá] FROM dbo.Bill AS b,dbo.TableFood AS t WHERE DateCheckIn >=@checkIn AND DateCheckOut <= @checkOut AND b.status = 1 AND t.id = b.idTable
	PRINT @checkOut 
END

GO
/****** Object:  StoredProcedure [dbo].[USP_GetTableList]    Script Date: 11/10/2019 10:10:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_GetTableList]
AS
SELECT * FROM dbo.TableFood

GO
/****** Object:  StoredProcedure [dbo].[USP_InsertBill]    Script Date: 11/10/2019 10:10:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_InsertBill]
@idTable int 
AS
BEGIN
	INSERT INTO dbo.Bill
	        ( DateCheckIn ,
	          DateCheckOut ,
	          idTable ,
	          status ,
	          discount ,
	          totalPrice ,
	          debt,
			  customerUserName
	        )
	VALUES  ( GETDATE() , -- DateCheckIn - date
	          Null , -- DateCheckOut - date
	          @idTable , -- idTable - int
	          0 , -- status - int
	          0 , -- discount - int
	          0.0 , -- totalPrice - float
	          N'Chưa Thanh Toán',  -- debt - nvarchar(100)
			  N''
	        )
END

GO
/****** Object:  StoredProcedure [dbo].[USP_InsertBillInfo]    Script Date: 11/10/2019 10:10:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_InsertBillInfo]
@idBill INT, @idFood INT, @count INT
AS
BEGIN

	DECLARE @isExitsBillInfo INT
	DECLARE @foodCount INT = 1
	
	SELECT @isExitsBillInfo = id, @foodCount = b.count 
	FROM dbo.BillInfo AS b 
	WHERE idBill = @idBill AND idFood = @idFood

	IF (@isExitsBillInfo > 0)
	BEGIN
		DECLARE @newCount INT = @foodCount + @count
		IF (@newCount > 0)
			UPDATE dbo.BillInfo	SET count = @foodCount + @count WHERE idFood = @idFood
		ELSE
			DELETE dbo.BillInfo WHERE idBill = @idBill AND idFood = @idFood

	END
	ELSE
	BEGIN
		INSERT	dbo.BillInfo
        ( idBill, idFood, count )
		VALUES  ( @idBill, -- idBill - int
          @idFood, -- idFood - int
          @count  -- count - int
          )
	END
END

GO
/****** Object:  StoredProcedure [dbo].[USP_Login]    Script Date: 11/10/2019 10:10:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_Login]
@userName nvarchar (100),
@passWord nvarchar (100)
AS
BEGIN
    SELECT * FROM dbo.Account WHERE Username = @userName AND PassWord = @passWord
END

GO
/****** Object:  StoredProcedure [dbo].[USP_SwitchTabel]    Script Date: 11/10/2019 10:10:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SwitchTabel]
@idTable1 INT, @idTable2 int
AS BEGIN

	DECLARE @idFirstBill int
	DECLARE @idSeconrdBill INT
	
	DECLARE @isFirstTablEmty INT = 1
	DECLARE @isSecondTablEmty INT = 1
	
	
	SELECT @idSeconrdBill = id FROM dbo.Bill WHERE idTable = @idTable2 AND status = 0
	SELECT @idFirstBill = id FROM dbo.Bill WHERE idTable = @idTable1 AND status = 0
	
	PRINT @idFirstBill
	PRINT @idSeconrdBill
	PRINT '-----------'
	
	IF (@idFirstBill IS NULL)
	BEGIN
		PRINT '0000001'
		INSERT dbo.Bill
		        ( DateCheckIn ,
		          DateCheckOut ,
		          idTable ,
		          status
		        )
		VALUES  ( GETDATE() , -- DateCheckIn - date
		          NULL , -- DateCheckOut - date
		          @idTable1 , -- idTable - int
		          0  -- status - int
		        )
		        
		SELECT @idFirstBill = MAX(id) FROM dbo.Bill WHERE idTable = @idTable1 AND status = 0
		
	END
	
	SELECT @isFirstTablEmty = COUNT(*) FROM dbo.BillInfo WHERE idBill = @idFirstBill
	
	PRINT @idFirstBill
	PRINT @idSeconrdBill
	PRINT '-----------'
	
	IF (@idSeconrdBill IS NULL)
	BEGIN
		PRINT '0000002'
		INSERT dbo.Bill
		        ( DateCheckIn ,
		          DateCheckOut ,
		          idTable ,
		          status
		        )
		VALUES  ( GETDATE() , -- DateCheckIn - date
		          NULL , -- DateCheckOut - date
		          @idTable2 , -- idTable - int
		          0  -- status - int
		        )
		SELECT @idSeconrdBill = MAX(id) FROM dbo.Bill WHERE idTable = @idTable2 AND status = 0
		
	END
	
	SELECT @isSecondTablEmty = COUNT(*) FROM dbo.BillInfo WHERE idBill = @idSeconrdBill
	
	PRINT @idFirstBill
	PRINT @idSeconrdBill
	PRINT '-----------'

	SELECT id INTO IDBillInfoTable FROM dbo.BillInfo WHERE idBill = @idSeconrdBill
	
	UPDATE dbo.BillInfo SET idBill = @idSeconrdBill WHERE idBill = @idFirstBill
	
	UPDATE dbo.BillInfo SET idBill = @idFirstBill WHERE id IN (SELECT * FROM IDBillInfoTable)
	
	DROP TABLE IDBillInfoTable
	
	IF (@isFirstTablEmty = 0)
		UPDATE dbo.TableFood SET status = N'Trống' WHERE id = @idTable2
		
	IF (@isSecondTablEmty= 0)
		UPDATE dbo.TableFood SET status = N'Trống' WHERE id = @idTable1
END

GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateAccount]    Script Date: 11/10/2019 10:10:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_UpdateAccount]
	@disPlayName nvarchar(100),
	@passWord nvarchar(100),
	@newpassWord nvarchar(100),
	@userName nvarchar(100)

AS 
BEGIN
	 DECLARE @isRightPass INT = 0
	 SELECT @isRightPass = COUNT (*) FROM dbo.Account WHERE Username = @userName AND PassWord = @passWord
	 IF(@isRightPass = 1)
		 BEGIN
	 		IF(@newpassWord IS NULL OR @newpassWord = '')
				BEGIN
					UPDATE dbo.Account SET DisplayName = @disPlayName WHERE Username = @userName
				END
			ELSE
					UPDATE dbo.Account SET DisplayName = @disPlayName, PassWord = @newpassWord WHERE Username = @userName
		 END
END

GO
/****** Object:  UserDefinedFunction [dbo].[fuConvert]    Script Date: 11/10/2019 10:10:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fuConvert] -- hàm chuyển có dấu thành k dấu
(
@input_string NVARCHAR
)
RETURNS VARCHAR
AS
BEGIN
DECLARE @l_str NVARCHAR(100);
SET @l_str = LTRIM(@input_string);
SET @l_str = LOWER(RTRIM(@input_string));

SET @l_str = REPLACE(@l_str, 'á', 'a');

SET @l_str = REPLACE(@l_str, 'à', 'a');
SET @l_str = REPLACE(@l_str, 'ả', 'a');
SET @l_str = REPLACE(@l_str, 'ã', 'a');
SET @l_str = REPLACE(@l_str, 'ạ', 'a');

SET @l_str = REPLACE(@l_str, 'â', 'a');
SET @l_str = REPLACE(@l_str, 'ấ', 'a');
SET @l_str = REPLACE(@l_str, 'ầ', 'a');
SET @l_str = REPLACE(@l_str, 'ẩ', 'a');
SET @l_str = REPLACE(@l_str, 'ẫ', 'a');
SET @l_str = REPLACE(@l_str, 'ậ', 'a');

SET @l_str = REPLACE(@l_str, 'ă', 'a');
SET @l_str = REPLACE(@l_str, 'ắ', 'a');
SET @l_str = REPLACE(@l_str, 'ằ', 'a');
SET @l_str = REPLACE(@l_str, 'ẳ', 'a');
SET @l_str = REPLACE(@l_str, 'ẵ', 'a');
SET @l_str = REPLACE(@l_str, 'ặ', 'a');

SET @l_str = REPLACE(@l_str, 'é', 'e');
SET @l_str = REPLACE(@l_str, 'è', 'e');
SET @l_str = REPLACE(@l_str, 'ẻ', 'e');
SET @l_str = REPLACE(@l_str, 'ẽ', 'e');
SET @l_str = REPLACE(@l_str, 'ẹ', 'e');

SET @l_str = REPLACE(@l_str, 'ê', 'e');
SET @l_str = REPLACE(@l_str, 'ế', 'e');
SET @l_str = REPLACE(@l_str, 'ề', 'e');
SET @l_str = REPLACE(@l_str, 'ể', 'e');
SET @l_str = REPLACE(@l_str, 'ễ', 'e');
SET @l_str = REPLACE(@l_str, 'ệ', 'e');

SET @l_str = REPLACE(@l_str, 'í', 'i');
SET @l_str = REPLACE(@l_str, 'ì', 'i');
SET @l_str = REPLACE(@l_str, 'ỉ', 'i');
SET @l_str = REPLACE(@l_str, 'ĩ', 'i');
SET @l_str = REPLACE(@l_str, 'ị', 'i');

SET @l_str = REPLACE(@l_str, 'ó', 'o');
SET @l_str = REPLACE(@l_str, 'ò', 'o');
SET @l_str = REPLACE(@l_str, 'ỏ', 'o');
SET @l_str = REPLACE(@l_str, 'õ', 'o');
SET @l_str = REPLACE(@l_str, 'ọ', 'o');

SET @l_str = REPLACE(@l_str, 'ô', 'o');
SET @l_str = REPLACE(@l_str, 'ố', 'o');
SET @l_str = REPLACE(@l_str, 'ồ', 'o');
SET @l_str = REPLACE(@l_str, 'ổ', 'o');
SET @l_str = REPLACE(@l_str, 'ỗ', 'o');
SET @l_str = REPLACE(@l_str, 'ộ', 'o');

SET @l_str = REPLACE(@l_str, 'ơ', 'o');
SET @l_str = REPLACE(@l_str, 'ớ', 'o');
SET @l_str = REPLACE(@l_str, 'ờ', 'o');
SET @l_str = REPLACE(@l_str, 'ở', 'o');
SET @l_str = REPLACE(@l_str, 'ỡ', 'o');
SET @l_str = REPLACE(@l_str, 'ợ', 'o');

SET @l_str = REPLACE(@l_str, 'ú', 'u');
SET @l_str = REPLACE(@l_str, 'ù', 'u');
SET @l_str = REPLACE(@l_str, 'ủ', 'u');
SET @l_str = REPLACE(@l_str, 'ũ', 'u');
SET @l_str = REPLACE(@l_str, 'ụ', 'u');

SET @l_str = REPLACE(@l_str, 'ư', 'u');
SET @l_str = REPLACE(@l_str, 'ứ', 'u');
SET @l_str = REPLACE(@l_str, 'ừ', 'u');
SET @l_str = REPLACE(@l_str, 'ử', 'u');
SET @l_str = REPLACE(@l_str, 'ữ', 'u');
SET @l_str = REPLACE(@l_str, 'ự', 'u');

SET @l_str = REPLACE(@l_str, 'ý', 'y');
SET @l_str = REPLACE(@l_str, 'ỳ', 'y');
SET @l_str = REPLACE(@l_str, 'ỷ', 'y');
SET @l_str = REPLACE(@l_str, 'ỹ', 'y');
SET @l_str = REPLACE(@l_str, 'ỵ', 'y');

SET @l_str = REPLACE(@l_str, 'đ', 'd');
SET @l_str = REPLACE(@l_str, ' ', '-');
SET @l_str = REPLACE(@l_str, '~', '-');
SET @l_str = REPLACE(@l_str, '?', '-');
SET @l_str = REPLACE(@l_str, '@', '-');
SET @l_str = REPLACE(@l_str, '#', '-');
SET @l_str = REPLACE(@l_str, '$', '-');
SET @l_str = REPLACE(@l_str, '^', '-');
SET @l_str = REPLACE(@l_str, '&', '-');
SET @l_str = REPLACE(@l_str, '/', '-');

SET @l_str = REPLACE(@l_str, '(', '');
SET @l_str = REPLACE(@l_str, ')', '');
SET @l_str = REPLACE(@l_str, '[', '');
SET @l_str = REPLACE(@l_str, ']', '');
SET @l_str = REPLACE(@l_str, '{', '');
SET @l_str = REPLACE(@l_str, '}', '');
SET @l_str = REPLACE(@l_str, '<', '');
SET @l_str = REPLACE(@l_str, '>', '');
SET @l_str = REPLACE(@l_str, '|', '');
SET @l_str = REPLACE(@l_str, '"', '');
SET @l_str = REPLACE(@l_str, '%', '');
SET @l_str = REPLACE(@l_str, '^', '');
SET @l_str = REPLACE(@l_str, '*', '');
SET @l_str = REPLACE(@l_str, '!', '');
SET @l_str = REPLACE(@l_str, ',', '');
SET @l_str = REPLACE(@l_str, '.', '');

SET @l_str = REPLACE(@l_str, '---', '-');
SET @l_str = REPLACE(@l_str, '--', '-');

RETURN @l_str;
END

GO
/****** Object:  UserDefinedFunction [dbo].[utf8ConvertSQL]    Script Date: 11/10/2019 10:10:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[utf8ConvertSQL]
(
@strInput nvarchar(4000)
)
RETURNS nvarchar(4000)
AS
BEGIN
SET @strInput = RTRIM(LTRIM(LOWER(@strInput)));
IF @strInput IS NULL
BEGIN
RETURN @strInput;
END;
IF @strInput = ''
BEGIN
RETURN @strInput;
END;
DECLARE @text nvarchar(50), @i int;
SET @text = '-''`~!@#$%^&*()?><:|}{,./\"''='';–';
SELECT @i = PATINDEX('%['+@text+']%', @strInput);
WHILE @i > 0
BEGIN
SET @strInput = replace(@strInput, SUBSTRING(@strInput, @i, 1), '');
SET @i = PATINDEX('%['+@text+']%', @strInput);
END;
SET @strInput = replace(@strInput, ' ', ' ');

DECLARE @RT nvarchar(4000);
DECLARE @SIGN_CHARS nchar(136);
DECLARE @UNSIGN_CHARS nchar(136);
SET @SIGN_CHARS = N'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệế
ìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵý'+NCHAR(272)+NCHAR(208);
SET @UNSIGN_CHARS = N'aadeoouaaaaaaaaaaaaaaaeeeeeeeeee
iiiiiooooooooooooooouuuuuuuuuuyyyyy';
DECLARE @COUNTER int;
DECLARE @COUNTER1 int;
SET @COUNTER = 1;
WHILE(@COUNTER <= LEN(@strInput))
BEGIN
SET @COUNTER1 = 1;
WHILE(@COUNTER1 <= LEN(@SIGN_CHARS) + 1)
BEGIN
IF UNICODE(SUBSTRING(@SIGN_CHARS, @COUNTER1, 1)) = UNICODE(SUBSTRING(@strInput, @COUNTER, 1))
BEGIN
IF @COUNTER = 1
BEGIN
SET @strInput = SUBSTRING(@UNSIGN_CHARS, @COUNTER1, 1) + SUBSTRING(@strInput, @COUNTER+1, LEN(@strInput)-1);
END;
ELSE
BEGIN
SET @strInput = SUBSTRING(@strInput, 1, @COUNTER-1) + SUBSTRING(@UNSIGN_CHARS, @COUNTER1, 1) + SUBSTRING(@strInput, @COUNTER+1, LEN(@strInput)-@COUNTER);
END;
BREAK;
END;
SET @COUNTER1 = @COUNTER1 + 1;
END;
SET @COUNTER = @COUNTER + 1;
END;
SET @strInput = replace(@strInput, ' ', '-');
RETURN LOWER(@strInput);
END

GO
/****** Object:  Table [dbo].[Account]    Script Date: 11/10/2019 10:10:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Account](
	[Username] [nvarchar](100) NOT NULL,
	[DisplayName] [nvarchar](1000) NOT NULL DEFAULT (N'Họ_tên'),
	[PassWord] [nvarchar](1000) NOT NULL DEFAULT ('0000'),
	[Type] [int] NOT NULL,
	[AccType] [nvarchar](1000) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Bill]    Script Date: 11/10/2019 10:10:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bill](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[DateCheckIn] [date] NOT NULL DEFAULT (getdate()),
	[DateCheckOut] [date] NULL,
	[idTable] [int] NOT NULL,
	[status] [int] NOT NULL DEFAULT ((0)),
	[discount] [int] NULL,
	[totalPrice] [float] NOT NULL,
	[debt] [nvarchar](100) NULL DEFAULT (N'Đã Thanh Toán'),
	[customerUserName] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BillInfo]    Script Date: 11/10/2019 10:10:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BillInfo](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idBill] [int] NOT NULL,
	[idFood] [int] NOT NULL,
	[count] [int] NOT NULL DEFAULT ((0)),
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Customer]    Script Date: 11/10/2019 10:10:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[CustomId] [int] IDENTITY(1,1) NOT NULL,
	[GuesName] [nvarchar](100) NOT NULL,
	[Addresss] [nvarchar](100) NOT NULL,
	[Number] [nvarchar](100) NOT NULL,
	[DateCheckOut] [date] NULL DEFAULT (getdate()),
PRIMARY KEY CLUSTERED 
(
	[CustomId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Food]    Script Date: 11/10/2019 10:10:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Food](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL DEFAULT (N'Chưa đặt tên'),
	[idCategory] [int] NOT NULL,
	[price] [float] NOT NULL DEFAULT ((0)),
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FoodCategory]    Script Date: 11/10/2019 10:10:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FoodCategory](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL DEFAULT (N'Chưa đặt tên'),
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TableFood]    Script Date: 11/10/2019 10:10:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TableFood](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL DEFAULT (N'Chưa có tên'),
	[status] [nvarchar](100) NOT NULL DEFAULT (N'Trống'),
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
INSERT [dbo].[Account] ([Username], [DisplayName], [PassWord], [Type], [AccType]) VALUES (N'Admin', N'Nguyễn Hoàng Bách', N'1998', 1, N'Quản Lý')
INSERT [dbo].[Account] ([Username], [DisplayName], [PassWord], [Type], [AccType]) VALUES (N'Employ1', N'Nhân Viên 1', N'', 0, N'Nhân Viên')
INSERT [dbo].[Account] ([Username], [DisplayName], [PassWord], [Type], [AccType]) VALUES (N'Employ2', N'Nhân Viên 2', N'0000', 0, N'Nhân Viên')
INSERT [dbo].[Account] ([Username], [DisplayName], [PassWord], [Type], [AccType]) VALUES (N'Employ3', N'Nhân Viên 3', N'0000', 0, N'Nhân Viên')
SET IDENTITY_INSERT [dbo].[Bill] ON 

INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (69, CAST(N'2019-10-21' AS Date), CAST(N'2019-10-21' AS Date), 65, 1, 20, 0, N'Đã Thanh Toán', NULL)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (70, CAST(N'2019-10-21' AS Date), CAST(N'2019-10-21' AS Date), 64, 1, 0, 0, N'Đã Thanh Toán', NULL)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (71, CAST(N'2019-10-21' AS Date), CAST(N'2019-10-21' AS Date), 69, 1, 50, 0, N'Đã Thanh Toán', NULL)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (72, CAST(N'2019-10-21' AS Date), CAST(N'2019-10-23' AS Date), 64, 1, 0, 0, N'Đã Thanh Toán', NULL)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (73, CAST(N'2019-10-21' AS Date), CAST(N'2019-10-21' AS Date), 83, 1, 0, 0, N'Đã Thanh Toán', NULL)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (74, CAST(N'2019-10-21' AS Date), CAST(N'2019-10-21' AS Date), 77, 1, 0, 0, N'Đã Thanh Toán', NULL)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (83, CAST(N'2019-10-24' AS Date), CAST(N'2019-10-24' AS Date), 64, 1, 0, 0, N'Đã Thanh Toán', NULL)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (84, CAST(N'2019-10-24' AS Date), CAST(N'2019-10-24' AS Date), 64, 1, 0, 0, N'Đã Thanh Toán', NULL)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (85, CAST(N'2019-10-24' AS Date), CAST(N'2019-10-24' AS Date), 65, 1, 0, 0, N'Đã Thanh Toán', NULL)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (86, CAST(N'2019-10-24' AS Date), CAST(N'2019-10-24' AS Date), 66, 1, 0, 120000, N'Đã Thanh Toán', NULL)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (87, CAST(N'2019-10-24' AS Date), CAST(N'2019-10-24' AS Date), 67, 1, 0, 20000, N'Đã Thanh Toán', NULL)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (88, CAST(N'2019-10-24' AS Date), CAST(N'2019-10-24' AS Date), 65, 1, 0, 10000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (89, CAST(N'2019-10-24' AS Date), CAST(N'2019-10-24' AS Date), 72, 1, 0, 0, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (90, CAST(N'2019-10-24' AS Date), CAST(N'2019-10-24' AS Date), 74, 1, 0, 1640000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (91, CAST(N'2019-10-24' AS Date), CAST(N'2019-10-24' AS Date), 64, 1, 0, 60000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (92, CAST(N'2019-10-24' AS Date), CAST(N'2019-10-24' AS Date), 77, 1, 0, 510000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (93, CAST(N'2019-10-24' AS Date), CAST(N'2019-10-24' AS Date), 71, 1, 0, 630000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (94, CAST(N'2019-10-24' AS Date), CAST(N'2019-10-24' AS Date), 66, 1, 0, 10000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (95, CAST(N'2019-10-24' AS Date), CAST(N'2019-10-24' AS Date), 69, 1, 0, 1600000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (96, CAST(N'2019-10-24' AS Date), CAST(N'2019-10-24' AS Date), 79, 1, 0, 1600000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (97, CAST(N'2019-10-24' AS Date), CAST(N'2019-10-24' AS Date), 68, 1, 0, 1600000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (98, CAST(N'2019-10-24' AS Date), CAST(N'2019-10-24' AS Date), 72, 1, 0, 1600000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (99, CAST(N'2019-10-24' AS Date), CAST(N'2019-10-24' AS Date), 65, 1, 0, 1600000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (100, CAST(N'2019-10-24' AS Date), CAST(N'2019-10-24' AS Date), 76, 1, 0, 120000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (101, CAST(N'2019-10-24' AS Date), CAST(N'2019-10-24' AS Date), 70, 1, 0, 1600000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (102, CAST(N'2019-10-24' AS Date), CAST(N'2019-10-24' AS Date), 67, 1, 0, 1600000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (103, CAST(N'2019-10-24' AS Date), CAST(N'2019-10-24' AS Date), 73, 1, 0, 1600000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (104, CAST(N'2019-10-24' AS Date), CAST(N'2019-10-24' AS Date), 78, 1, 0, 1600000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (105, CAST(N'2019-10-24' AS Date), CAST(N'2019-10-24' AS Date), 75, 1, 0, 1600000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (106, CAST(N'2019-10-24' AS Date), CAST(N'2019-10-24' AS Date), 81, 1, 0, 1600000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (107, CAST(N'2019-10-24' AS Date), CAST(N'2019-10-24' AS Date), 80, 1, 0, 1600000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (108, CAST(N'2019-10-24' AS Date), CAST(N'2019-10-24' AS Date), 82, 1, 0, 1600000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (109, CAST(N'2019-10-24' AS Date), CAST(N'2019-10-24' AS Date), 83, 1, 0, 1600000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (110, CAST(N'2019-10-24' AS Date), CAST(N'2019-10-24' AS Date), 64, 1, 0, 400000, N'Đã Thanh Toán', 2)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (119, CAST(N'2019-10-25' AS Date), CAST(N'2019-10-25' AS Date), 64, 1, 0, 400000, N'Đã Thanh Toán', 7)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (120, CAST(N'2019-10-25' AS Date), CAST(N'2019-10-25' AS Date), 65, 1, 0, 200000, N'Đã Thanh Toán', 2)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (121, CAST(N'2019-10-25' AS Date), CAST(N'2019-10-25' AS Date), 66, 1, 0, 3200000, N'Đã Thanh Toán', 16)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (122, CAST(N'2019-10-25' AS Date), CAST(N'2019-10-25' AS Date), 65, 1, 0, 600000, N'Đã Thanh Toán', 10)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (123, CAST(N'2019-10-25' AS Date), CAST(N'2019-10-25' AS Date), 67, 1, 0, 580000, N'Đã Thanh Toán', 18)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (124, CAST(N'2019-10-25' AS Date), CAST(N'2019-10-25' AS Date), 68, 1, 0, 600000, N'Đã Thanh Toán', 14)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (125, CAST(N'2019-10-25' AS Date), CAST(N'2019-10-25' AS Date), 64, 1, 0, 100000, N'Chưa Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (126, CAST(N'2019-10-25' AS Date), CAST(N'2019-10-25' AS Date), 64, 1, 0, 50000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (127, CAST(N'2019-10-25' AS Date), CAST(N'2019-10-25' AS Date), 67, 1, 0, 50000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (128, CAST(N'2019-10-25' AS Date), CAST(N'2019-10-25' AS Date), 77, 1, 0, 0, N'Chưa Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (129, CAST(N'2019-10-25' AS Date), CAST(N'2019-10-25' AS Date), 77, 1, 0, 0, N'Chưa Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (130, CAST(N'2019-10-25' AS Date), CAST(N'2019-10-25' AS Date), 77, 1, 0, 500000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (131, CAST(N'2019-10-25' AS Date), CAST(N'2019-10-25' AS Date), 73, 1, 0, 6300000, N'Chưa Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (132, CAST(N'2019-10-25' AS Date), CAST(N'2019-10-25' AS Date), 69, 1, 0, 1000000, N'Chưa Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (133, CAST(N'2019-10-25' AS Date), CAST(N'2019-10-25' AS Date), 69, 1, 20, 800000, N'Đã Thanh Toán', 20)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (134, CAST(N'2019-10-25' AS Date), CAST(N'2019-10-25' AS Date), 68, 1, 20, 320000, N'Đã Thanh Toán', 22)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (135, CAST(N'2019-10-25' AS Date), CAST(N'2019-10-25' AS Date), 64, 1, 0, 400000, N'Chưa Thanh Toán', 24)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (136, CAST(N'2019-10-26' AS Date), CAST(N'2019-10-26' AS Date), 64, 1, 0, 1000000, N'Chưa Thanh Toán', 26)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (138, CAST(N'2019-10-26' AS Date), CAST(N'2019-10-27' AS Date), 64, 1, 0, 400000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (139, CAST(N'2019-10-28' AS Date), CAST(N'2019-10-28' AS Date), 64, 1, 0, 400000, N'Chưa Thanh Toán', 28)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (140, CAST(N'2019-10-28' AS Date), CAST(N'2019-11-02' AS Date), 64, 1, 0, 1250000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (141, CAST(N'2019-11-01' AS Date), CAST(N'2019-11-02' AS Date), 65, 1, 0, 800000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (142, CAST(N'2019-11-01' AS Date), CAST(N'2019-11-02' AS Date), 66, 1, 0, 800000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (143, CAST(N'2019-11-01' AS Date), CAST(N'2019-11-02' AS Date), 79, 1, 0, 5000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (144, CAST(N'2019-11-01' AS Date), CAST(N'2019-11-02' AS Date), 80, 1, 0, 5000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (145, CAST(N'2019-11-02' AS Date), CAST(N'2019-11-02' AS Date), 64, 1, 0, 400000, N'Chưa Thanh Toán', 30)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (146, CAST(N'2019-11-02' AS Date), CAST(N'2019-11-02' AS Date), 65, 1, 0, 0, N'Chưa Thanh Toán', 32)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (147, CAST(N'2019-11-02' AS Date), CAST(N'2019-11-02' AS Date), 64, 1, 0, 0, N'Chưa Thanh Toán', 34)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (148, CAST(N'2019-11-02' AS Date), CAST(N'2019-11-02' AS Date), 64, 1, 0, 200000, N'Đã Thanh Toán', 36)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (149, CAST(N'2019-11-02' AS Date), CAST(N'2019-11-02' AS Date), 64, 1, 0, 0, N'Chưa Thanh Toán', 38)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (150, CAST(N'2019-11-02' AS Date), CAST(N'2019-11-02' AS Date), 65, 1, 0, 1000000, N'Chưa Thanh Toán', 40)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (151, CAST(N'2019-11-02' AS Date), CAST(N'2019-11-02' AS Date), 64, 1, 0, 0, N'Chưa Thanh Toán', 41)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (152, CAST(N'2019-11-02' AS Date), CAST(N'2019-11-02' AS Date), 64, 1, 0, 200000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (153, CAST(N'2019-11-02' AS Date), CAST(N'2019-11-02' AS Date), 64, 1, 0, 200000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (154, CAST(N'2019-11-02' AS Date), CAST(N'2019-11-02' AS Date), 64, 1, 0, 200000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (155, CAST(N'2019-11-02' AS Date), CAST(N'2019-11-02' AS Date), 72, 1, 0, 200000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (156, CAST(N'2019-11-02' AS Date), CAST(N'2019-11-02' AS Date), 64, 1, 0, 0, N'Chưa Thanh Toán', 42)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (157, CAST(N'2019-11-02' AS Date), CAST(N'2019-11-02' AS Date), 64, 1, 0, 400000, N'Đã Thanh Toán', 43)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (158, CAST(N'2019-11-02' AS Date), CAST(N'2019-11-02' AS Date), 64, 1, 0, 200000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (159, CAST(N'2019-11-02' AS Date), CAST(N'2019-11-02' AS Date), 64, 1, 0, 200000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (160, CAST(N'2019-11-02' AS Date), CAST(N'2019-11-02' AS Date), 64, 1, 0, 200000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (161, CAST(N'2019-11-02' AS Date), CAST(N'2019-11-02' AS Date), 64, 1, 0, 200000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (162, CAST(N'2019-11-02' AS Date), CAST(N'2019-11-02' AS Date), 64, 1, 0, 200000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (163, CAST(N'2019-11-02' AS Date), CAST(N'2019-11-03' AS Date), 64, 1, 0, 400000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (165, CAST(N'2019-11-03' AS Date), CAST(N'2019-11-03' AS Date), 65, 1, 0, 400000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (167, CAST(N'2019-11-03' AS Date), CAST(N'2019-11-03' AS Date), 70, 1, 0, 400000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (170, CAST(N'2019-11-03' AS Date), CAST(N'2019-11-03' AS Date), 64, 1, 0, 200000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (172, CAST(N'2019-11-03' AS Date), CAST(N'2019-11-03' AS Date), 64, 1, 0, 200000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (173, CAST(N'2019-11-03' AS Date), CAST(N'2019-11-03' AS Date), 64, 1, 0, 400000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (174, CAST(N'2019-11-03' AS Date), CAST(N'2019-11-05' AS Date), 65, 1, 0, 400000, N'Đã Thanh Toán', 0)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (175, CAST(N'2019-11-03' AS Date), CAST(N'2019-11-03' AS Date), 68, 1, 0, 1000000, N'Chưa Thanh Toán', 44)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [debt], [customerUserName]) VALUES (176, CAST(N'2019-11-10' AS Date), NULL, 64, 0, 0, 1375000, N'Chưa Thanh Toán', 0)
SET IDENTITY_INSERT [dbo].[Bill] OFF
SET IDENTITY_INSERT [dbo].[BillInfo] ON 

INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (85, 68, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (86, 69, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (87, 69, 4, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (89, 71, 2, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (90, 72, 11, 5)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (92, 74, 11, 5)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (93, 83, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (94, 84, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (95, 85, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (96, 86, 8, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (97, 87, 5, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (98, 88, 12, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (99, 89, 7, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (100, 90, 9, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (101, 90, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (102, 91, 4, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (103, 92, 6, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (104, 93, 5, 4)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (105, 93, 6, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (106, 93, 7, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (107, 91, 7, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (108, 92, 11, 5)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (109, 94, 11, 5)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (110, 95, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (111, 96, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (112, 97, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (113, 98, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (114, 99, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (115, 100, 8, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (116, 101, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (117, 102, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (118, 103, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (119, 104, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (120, 105, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (121, 106, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (122, 107, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (123, 108, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (124, 109, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (125, 110, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (126, 111, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (127, 112, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (128, -1, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (129, 113, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (130, 114, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (131, 115, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (132, 116, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (133, 117, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (134, 118, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (135, 118, 11, 5)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (136, 119, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (137, 120, 2, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (138, 119, 2, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (139, 121, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (140, 122, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (141, 123, 4, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (142, 123, 5, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (143, 123, 6, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (144, 123, 7, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (145, 124, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (146, 124, 2, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (147, 124, 3, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (148, 125, 4, 3)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (149, 125, 5, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (150, 125, 7, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (151, 126, 7, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (152, 127, 7, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (153, 128, 6, 6)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (154, 129, 6, 5)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (155, 130, 6, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (156, 121, 3, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (157, 131, 3, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (158, 132, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (159, 133, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (160, 134, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (161, 135, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (162, 136, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (163, 137, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (164, 138, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (165, 139, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (166, 140, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (167, 140, 2, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (168, 141, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (169, 142, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (170, 143, 13, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (171, 144, 13, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (172, 140, 3, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (173, 140, 11, 5)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (174, 145, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (175, 146, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (176, 147, 8, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (177, 148, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (178, 149, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (179, 150, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (180, 151, 3, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (181, 152, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (182, 153, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (183, 154, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (184, 155, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (185, 156, 1, 2)
GO
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (186, 157, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (187, 158, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (188, 159, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (189, 160, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (190, 161, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (191, 162, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (192, 165, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (193, 163, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (194, 167, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (195, 170, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (196, 172, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (197, 173, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (198, 174, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (199, 175, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (200, 175, 3, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (201, 176, 1, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (202, 176, 2, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (203, 176, 3, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (204, 176, 4, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (205, 176, 5, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (206, 176, 6, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (207, 176, 7, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (208, 176, 8, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (209, 176, 9, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (210, 176, 10, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (211, 176, 11, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (212, 176, 12, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (213, 176, 13, 1)
SET IDENTITY_INSERT [dbo].[BillInfo] OFF
SET IDENTITY_INSERT [dbo].[Customer] ON 

INSERT [dbo].[Customer] ([CustomId], [GuesName], [Addresss], [Number], [DateCheckOut]) VALUES (28, N'Phan Thị Mai', N'yên Thành- Nghệ AN', N'123456789', CAST(N'2019-10-28' AS Date))
INSERT [dbo].[Customer] ([CustomId], [GuesName], [Addresss], [Number], [DateCheckOut]) VALUES (30, N'Nguyễn Công Thành ', N'Yên Thành ', N'123456789878', CAST(N'2019-11-02' AS Date))
INSERT [dbo].[Customer] ([CustomId], [GuesName], [Addresss], [Number], [DateCheckOut]) VALUES (35, N'Cao Chí Nhân', N'Hà Tĩnh', N'12345678987', CAST(N'2019-11-02' AS Date))
INSERT [dbo].[Customer] ([CustomId], [GuesName], [Addresss], [Number], [DateCheckOut]) VALUES (36, N'Cao Chí Nhân', N'Hà Tĩnh', N'12345678987', CAST(N'2019-11-02' AS Date))
INSERT [dbo].[Customer] ([CustomId], [GuesName], [Addresss], [Number], [DateCheckOut]) VALUES (37, N'Hồ Hoài Nam', N'Thái Hòa', N'2245784265', CAST(N'2019-11-02' AS Date))
INSERT [dbo].[Customer] ([CustomId], [GuesName], [Addresss], [Number], [DateCheckOut]) VALUES (38, N'Hồ Hoài Nam', N'Thái Hòa', N'2245784265', CAST(N'2019-11-02' AS Date))
INSERT [dbo].[Customer] ([CustomId], [GuesName], [Addresss], [Number], [DateCheckOut]) VALUES (39, N'Trịnh Ngọc Minh', N'Quảng Bình ', N'5465464', CAST(N'2019-11-02' AS Date))
INSERT [dbo].[Customer] ([CustomId], [GuesName], [Addresss], [Number], [DateCheckOut]) VALUES (40, N'Trịnh Ngọc Minh', N'Quảng Bình ', N'5465464', CAST(N'2019-11-02' AS Date))
INSERT [dbo].[Customer] ([CustomId], [GuesName], [Addresss], [Number], [DateCheckOut]) VALUES (41, N'Nguyễn Văn A', N'Việt Nam', N'46546464654', CAST(N'2019-11-02' AS Date))
INSERT [dbo].[Customer] ([CustomId], [GuesName], [Addresss], [Number], [DateCheckOut]) VALUES (42, N'Nguyễn Tất Mèo', N'Đô Lương', N'12121212121', CAST(N'2019-11-02' AS Date))
INSERT [dbo].[Customer] ([CustomId], [GuesName], [Addresss], [Number], [DateCheckOut]) VALUES (43, N'Nguyễn Văn B', N'Việt Nam', N'1212121212', CAST(N'2019-11-02' AS Date))
INSERT [dbo].[Customer] ([CustomId], [GuesName], [Addresss], [Number], [DateCheckOut]) VALUES (44, N'Phan Thị Mai', N'Yên Thành ', N'123456789', CAST(N'2019-11-03' AS Date))
SET IDENTITY_INSERT [dbo].[Customer] OFF
SET IDENTITY_INSERT [dbo].[Food] ON 

INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (1, N'Cá Mập Chết Đuối', 1, 200000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (2, N'Mực Nhiều Nắng', 1, 100000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (3, N'Bạch Tuộc Đứt Vòi', 1, 300000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (4, N'Cơm Chiên Dương Châu', 2, 10000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (5, N'Rau Muống Xào Tỏi Ớt', 2, 20000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (6, N'Heo Sữa Quay Cả Con', 2, 500000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (7, N'Salad Hoa Quả', 2, 50000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (8, N'Gà Không Lối Thoát', 3, 120000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (9, N'Trứng Rán Bóng Đêm', 3, 40000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (10, N'Chim Sẻ Đi Lẻ', 3, 10000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (11, N'7Up', 4, 10000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (12, N'CoCalCoLa', 4, 10000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (13, N'Thạch Thủy Dầm Băng', 4, 5000)
SET IDENTITY_INSERT [dbo].[Food] OFF
SET IDENTITY_INSERT [dbo].[FoodCategory] ON 

INSERT [dbo].[FoodCategory] ([id], [name]) VALUES (1, N'Hải Sản')
INSERT [dbo].[FoodCategory] ([id], [name]) VALUES (2, N'Nông Sản')
INSERT [dbo].[FoodCategory] ([id], [name]) VALUES (3, N'Lâm Sản')
INSERT [dbo].[FoodCategory] ([id], [name]) VALUES (4, N'Nước')
INSERT [dbo].[FoodCategory] ([id], [name]) VALUES (13, N'Vũ Trụ Sản')
SET IDENTITY_INSERT [dbo].[FoodCategory] OFF
SET IDENTITY_INSERT [dbo].[TableFood] ON 

INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (64, N'Bàn 1', N'Có Người')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (65, N'Bàn 2', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (66, N'Bàn 3', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (67, N'Bàn 4', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (68, N'Bàn 5', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (69, N'Bàn 6', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (70, N'Bàn 7', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (71, N'Bàn 8', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (72, N'Bàn 9', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (73, N'Bàn 10', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (74, N'Bàn 11', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (75, N'Bàn 12', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (76, N'Bàn 13', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (77, N'Bàn 14', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (78, N'Bàn 15', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (79, N'Bàn 16', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (80, N'Bàn 17', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (81, N'Bàn 18', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (82, N'Bàn 19', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (83, N'Bàn 20', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (85, N'Bàn 21', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (86, N'Bàn 22', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (87, N'Bàn 23', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (92, N'Bàn 24', N'Trống')
SET IDENTITY_INSERT [dbo].[TableFood] OFF
ALTER TABLE [dbo].[Bill]  WITH CHECK ADD  CONSTRAINT [FK_Bill_TableFood] FOREIGN KEY([idTable])
REFERENCES [dbo].[TableFood] ([id])
GO
ALTER TABLE [dbo].[Bill] CHECK CONSTRAINT [FK_Bill_TableFood]
GO
ALTER TABLE [dbo].[BillInfo]  WITH CHECK ADD FOREIGN KEY([idFood])
REFERENCES [dbo].[Food] ([id])
GO
ALTER TABLE [dbo].[Food]  WITH CHECK ADD FOREIGN KEY([idCategory])
REFERENCES [dbo].[FoodCategory] ([id])
GO
USE [master]
GO
ALTER DATABASE [DoAnCuaBach] SET  READ_WRITE 
GO
