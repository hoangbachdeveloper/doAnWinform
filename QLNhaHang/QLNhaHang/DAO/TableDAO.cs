using QLNhaHang.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QLNhaHang.DAO
{
    public class TableDAO
    {
        private static TableDAO instance;
        public static TableDAO Instance
        {
            get
            {
                if (instance == null)
                    instance = new TableDAO();
                return TableDAO.instance;
            }

            private set
            {
                TableDAO.instance = value;
            }
        }
        public static int TableWidth = 120;
        public static int TableHeight = 120;
        public void SwitchTable(int id1, int id2)
        {
            DataProvider.Instance.ExecuteQuery("[dbo].[USP_SwitchTabel] @idTable1 , @idTable2 ", new object[] { id1, id2 });
        }
        public DataTable GetLisstBillInfoByTable()
        {
            string query = "SELECT f.name AS [Tên Món], bi.count [Số Lượng], b.discount AS [Giảm Giá], b.totalPrice AS [Tổng Tiền] FROM dbo.TableFood AS t, dbo.BillInfo AS bi, dbo.Food AS f, dbo.Bill AS b  WHERE t.id = 65 AND bi.idBill = b.id AND bi.idFood = f.id AND b.DateCheckIn >= '10/20/2019' AND b.DateCheckOut <= '10/21/2019' AND t.status = N'Trống'";
            return DataProvider.Instance.ExecuteQuery(query);
        }
        public bool InsertTable(String name)
        {
            string query = string.Format("INSERT INTO dbo.TableFood( name ) VALUES  ( N'{0}')", name);
            int result = DataProvider.Instance.ExecuteNonQuery(query);
            return result > 0;
        }
        public List<Table> LoadTableList()
        {
            List<Table> tablelist = new List<Table>();
            DataTable data = DataProvider.Instance.ExecuteQuery("USP_GetTableList");
            foreach (DataRow item in data.Rows)
            {
                Table table = new Table(item);
                tablelist.Add(table);
            }
            return tablelist;
        }
        public DataTable GetListTable()
        {
            string query = "SELECT id AS [Mã Bàn], name AS [Tên Bàn], status AS [Trạng Thái] FROM dbo.TableFood ";
            return DataProvider.Instance.ExecuteQuery(query);
        }
        public bool UpdateTable(String name, string idTable)
        {
            string query = string.Format("UPDATE dbo.TableFood SET name = N'{0}' where id = {1}", name, idTable);
            int result = DataProvider.Instance.ExecuteNonQuery(query);
            return result > 0;
        }
        public List<Table> GetTableName(int id)
        {
            List<Table> t = new List<Table>();
            string query = "SELECT name FROM dbo.TableFood WHERE id = " + id;
            DataTable a = (DataProvider.Instance.ExecuteQuery(query));
            foreach (DataRow item in a.Rows)
            {
                Table table = new Table(item);
                t.Add(table);
            }
            return t;
        }
        public bool DeleteTable(int idTable)
        {
            BillDAO.Instance.DeleteBill(idTable);
            string query = string.Format("DELETE dbo.TableFood WHERE id = {0}", idTable);
            int result = DataProvider.Instance.ExecuteNonQuery(query);
            return result > 0;
        }
    }
        
}
