using QLNhaHang.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QLNhaHang.DAO
{
    public class BillDAO
    {
        private static BillDAO instance;

        public static BillDAO Instance
        {
            get
            {
                if (instance == null)
                    instance = new BillDAO();
                return BillDAO.instance;
            }

            private set
            {
                BillDAO.instance = value;
            }
        }
        private BillDAO() { }
        public int GetUncheckBillIdByTableId(int id)
        {
            DataTable data = DataProvider.Instance.ExecuteQuery("SELECT * FROM Bill WHERE idTable = " + id + " AND status = 0");
            //lỗi auto insert billinfo nằm ở cái hàm này
            //xảy ra khi id luôn bằng -1 
            //cách sửa: để status về 0
            if (data.Rows.Count > 0)
            {
                Bill bill = new Bill(data.Rows[0]);
                return bill.ID;
            }
            return -1;
        }
        public DataTable GetBillListByDate(DateTime checkIn, DateTime checkOut)
        {
            return DataProvider.Instance.ExecuteQuery("exec USP_GetListBillByDate @checkIn , @checkOut", new object[] { checkIn, checkOut });  
        }
        public void CheckOutBillId(int id, float totalPrice, int discount)
        {
            string query = "UPDATE dbo.Bill SET DateCheckOut = GETDATE(), status = 1, debt = N'Đã Thanh Toán', discount = " + discount + ", totalPrice = " + totalPrice +   " WHERE id = " + id;
            DataProvider.Instance.ExecuteNonQuery(query);
        }
        public void UpdateDateCheckOut(int id)
        {
            string query = "UPDATE dbo.Bill SET DateCheckOut = GETDATE() WHERE id = " + id;
            DataProvider.Instance.ExecuteNonQuery(query);
        }
        public void UpdateTotalPrice(int id, float totalPrice)
        {
            string query = "UPDATE dbo.Bill SET  totalPrice ="+ totalPrice + " WHERE id =" + id;
            DataProvider.Instance.ExecuteNonQuery(query);
        }
        public void InsertBill(int id)
        {
            DataProvider.Instance.ExecuteNonQuery("EXEC USP_InsertBill @idTable ", new object[] {id});
            
        }
        public void UpdateBill(int id, float totalPrice)
        {
            string query = "UPDATE dbo.Bill SET totalPrice = " + totalPrice+ " where id = " + id ;
            DataProvider.Instance.ExecuteNonQuery(query);
        }
        public int GetMaxIdBill()
        {
            try
            {
                return (int)DataProvider.Instance.ExecuteScalar("SELECT MAX(id) FROM dbo.Bill");
            }
            catch
            {
                return 1;
            }
        }
        public void DeleteBill(int id)
        {
            string query = "DELETE dbo.Bill WHERE idTable = " + id;
            DataProvider.Instance.ExecuteQuery(query);
        }
        public void UpdateBillDisCount(int id)
        {
            string query = " UPDATE dbo.Bill SET DateCheckOut = GETDATE(), status = 1 WHERE id  = " + id;
            DataProvider.Instance.ExecuteQuery(query);
        }
        public void UpdateDisCount(int id, int disCount)
        {
            string query = " UPDATE dbo.Bill SET discount = " + disCount + " WHERE id  = " + id;
            DataProvider.Instance.ExecuteQuery(query);
        }
        public void UpdateToTalprice(string id, int totalPrice)
        {
            string query = " UPDATE dbo.Bill SET totalPrice = " + totalPrice + " WHERE id  = " + id;
            DataProvider.Instance.ExecuteQuery(query);
        }
        public void UpdateBillFinishDebt(int id)
        {
            string query = " UPDATE dbo.Bill SET debt = N'Đã Thanh Toán' WHERE id = " + id;
            DataProvider.Instance.ExecuteQuery(query);
        }      

    }
}
