using QLNhaHang.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QLNhaHang.DAO
{
    public class BillInforDAO
    {
        private static BillInforDAO instance;

        public static BillInforDAO Instance
        {
            get
            {
                if (instance == null)
                    instance = new BillInforDAO();
                return BillInforDAO.instance;
            }

           private set
            {
                BillInforDAO.instance = value;
            }
        }
        private BillInforDAO() { }
        public List<BillInfo> GetListBillInfor(int id)
        {
            List<BillInfo> listBillInfor = new List<BillInfo>();
            DataTable data = DataProvider.Instance.ExecuteQuery("SELECT * FROM dbo.BillInfo WHERE idBill = " + id);
            foreach (DataRow item in data.Rows)
            {
                BillInfo info = new BillInfo(item);
                listBillInfor.Add(info);
            }
            return listBillInfor;
        }
        public void DeletedBillInfoById(int id)
        {
            string query = string.Format("Delete dbo.BillInfo WHERE idFood = {0}", id);
            DataProvider.Instance.ExecuteQuery(query);
        }
        public void InserBillInfor(int idBill, int idFood, int count)
        {
            DataProvider.Instance.ExecuteNonQuery("USP_InsertBillInfo @idBill , @idFood , @count ", new object[] { idBill, idFood, count });
        }
    }
}
