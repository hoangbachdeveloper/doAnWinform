using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QLNhaHang.DAO
{
   public class CustomerDAO
    {
        private static CustomerDAO instance;

        public static CustomerDAO Instance
        {
            get
            {
                if (instance == null)
                    instance = new CustomerDAO();
                return CustomerDAO.instance;
            }

            set
            {
                CustomerDAO.instance = value;
            }
        }
        public DataTable GetGuess()
        {
            string query = "SELECT CustomId AS [Mã Ghi Nợ], GuesName AS [Tên Khách], Addresss AS [Địa Chỉ], Number AS [Số Điện Thoại], DateCheckOut AS [Ngày Ghi] FROM dbo.Customer";
            return DataProvider.Instance.ExecuteQuery(query);
        }
        public DataTable ViewCustomerDebt(string idBill)
        {
            string query = "SELECT b.id AS [Số Hóa Đơn], c.GuesName AS [Tên Khách], b.totalPrice as [Tổng Tiền], c.DateCheckOut AS [Ngày Ghi], c.Addresss AS [Địa Chỉ], c.Number AS [Số Điện Thoại] FROM dbo.Bill AS b, dbo.Customer AS c WHERE b.id = '" + idBill +"'" ;
            return DataProvider.Instance.ExecuteQuery(query);
        }
        public DataTable ViewCustomer()
        {
            string query = "SELECT  b.id AS [Số Hóa Đơn], c.CustomId AS [Mã Ghi Nợ], c.GuesName AS [Tên Khách], b.totalPrice AS [Tổng Nợ], c.DateCheckOut AS [Ngày Ghi], c.Addresss AS [Địa Chỉ], c.Number AS [Số Điện Thoại] FROM dbo.Bill AS b, dbo.Customer AS c WHERE b.debt = N'Chưa Thanh Toán' AND b.customerUserName	 = c.CustomId";
            return DataProvider.Instance.ExecuteQuery(query);
        }
        public DataTable UpdateCustomerToBill(string idBill, string customerName)
        {
            string query = "UPDATE dbo.Bill SET customerUserName = (SELECT MAX(CustomId) FROM dbo.Customer) WHERE id =" + idBill;
            return DataProvider.Instance.ExecuteQuery(query);
        }
        public bool DeleteGuess(string userName)
        {
            string query = string.Format("DELETE dbo.Customer WHERE CustomId = N'{0}'", userName);
            int result = DataProvider.Instance.ExecuteNonQuery(query);
            return result > 0;
        }

        public bool InsertGuess(string DisplayName, string Address, string number)
        {
            string query = string.Format("INSERT INTO dbo.Customer( GuesName ,Addresss ,Number) VALUES  ( N'{0}' ,N'{1}' , N'{2}')", DisplayName, Address, number);
            int result = DataProvider.Instance.ExecuteNonQuery(query);
            return result > 0;
        }
        public bool UpdateGuess(string userName, string DisplayName, string address, string number)
        {
            string query = string.Format("UPDATE dbo.Customer SET GuesName = N'{0}',  Addresss = N'{1}', Number = N'{2}' WHERE UserName = N'{3}'  ", DisplayName,  address , number , userName);
            int result = DataProvider.Instance.ExecuteNonQuery(query);
            return result > 0;
        }
        public bool ResetPass(string userName)
        {
            string query = string.Format("UPDATE dbo.Customer SET PassWord = N'0000' WHERE UserName = N'{0}'", userName);
            int result = DataProvider.Instance.ExecuteNonQuery(query);
            return result > 0;
        }
        public int GetMaxIdBill()
        {
            try
            {
                return (int)DataProvider.Instance.ExecuteScalar("SELECT MAX(CustomId) FROM dbo.Customer");
            }
            catch
            {
                return 1;
            }
        }
        public void CheckOutBillId(int id, float totalPrice, int discount)
        {
            string query = "UPDATE dbo.Bill SET DateCheckOut = GETDATE(), status = 1, debt = N'Chưa Thanh Toán', discount = " + discount + ", totalPrice = " + totalPrice + " WHERE id = " + id;
            DataProvider.Instance.ExecuteNonQuery(query);
        }
    }
}
