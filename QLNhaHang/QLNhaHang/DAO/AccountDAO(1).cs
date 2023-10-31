using QLNhaHang.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QLNhaHang.DAO
{
   public class AccountDAO
    {
        private static AccountDAO instance;

        public static AccountDAO Instance
        {
            get
            {
                if (instance == null)
                    instance = new AccountDAO();
                return AccountDAO.instance;
            }

            private set
            {
                AccountDAO.instance = value;
            }
        }
        public Account GetAccountByUserName(string userName)
        {
            DataTable data = DataProvider.Instance.ExecuteQuery("SELECT * FROM dbo.Account WHERE Username = '" + userName + "'");
            foreach (DataRow item in data.Rows)
            {
                return new Account(item);
            }
            return null;
        }
        public bool Login(string userName, string passWord)
        {
            string query = "USP_Login @userName  , @passWord ";
            DataTable result = DataProvider.Instance.ExecuteQuery(query, new object[] { userName, passWord});
            return result.Rows.Count > 0;
        }
        public DataTable GetListAcc()
        {
            string query = "SELECT Username AS [Tên Người Dùng], DisplayName AS [Tên Hiển Thị], AccType AS [Loại Tài Khoản] FROM  dbo.Account";
            return DataProvider.Instance.ExecuteQuery(query);
        }
        public bool UpdateAccount(string disPlayName, string password, string newpass, string username)
        {
            int result = DataProvider.Instance.ExecuteNonQuery("Exec USP_UpdateAccount  @disPlayName , @passWord , @newpassWord , @userName ", new object[] { disPlayName, password, newpass, username });
            return result > 0;
        }
        public bool UpdateAcc(String name, string DisPlayName, int Type, string AccType)
        { 
            string query = string.Format("UPDATE dbo.Account SET DisplayName = N'{0}', Type = {1}, AccType = N'{2}' WHERE UserName = N'{3}'", DisPlayName, Type, AccType, name);
            int result = DataProvider.Instance.ExecuteNonQuery(query);
            return result > 0;
        }
        public bool DeleteAccount(string userName)
        { 
            string query = string.Format("DELETE FROM dbo.Account WHERE Username = N'{0}'", userName);
            int result = DataProvider.Instance.ExecuteNonQuery(query);
            return result > 0;
        }
        public bool InsertAccount(string userName, string DisplayName, int Type, string AccType)
        {
            string query = string.Format("INSERT INTO dbo.Account ( Username, DisplayName, Type, AccType) VALUES  ( N'{0}', N'{1}',  {2}, N'{3}' )", userName, DisplayName, Type, AccType);
            int result = DataProvider.Instance.ExecuteNonQuery(query);
            return result > 0;
        }
        public bool UpdateAccount(string userName, string DisplayName, int Type, string AccType)
        {       
            string query = string.Format("UPDATE dbo.Account SET DisplayName = N'{0} ', Type = {1}, AccType = N'{2}' WHERE Username = N'{3}' ", DisplayName, Type, AccType, userName);
            int result = DataProvider.Instance.ExecuteNonQuery(query);
            return result > 0;
        }
        public bool ResetPass(string userName)
        {
            string query = string.Format("UPDATE  dbo.Account SET PassWord = N'0000' WHERE Username = N'{0}'", userName);
            int result = DataProvider.Instance.ExecuteNonQuery(query);
            return result > 0;
        }
    }
}
