using QLNhaHang.DAO;
using QLNhaHang.DTO;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QLNhaHang
{
    public partial class fDebt : Form
    {
        public fDebt()
        {
            InitializeComponent();
            LoadBill();
            AddCustomToDebt(); 
        }

        #region method
        public bool debt = false;        
        void LoadBill()
        {
            try
            {
                string todate = tpToDate.Value.ToShortDateString();
                SqlConnection cnn = new SqlConnection(DataProvider.Instance.ConnectionString);
                cnn.Open();
                string query = "SELECT b.id AS [Số Hóa Đơn], t.name AS [Tên bàn], b.debt AS [Trạng Thái], b.totalPrice AS [Tổng tiền],  DateCheckOut AS [Ngày Ghi], discount AS [Giảm giá (%)] FROM dbo.Bill AS b,dbo.TableFood AS t WHERE DateCheckIn = '" + todate + "' AND b.status = 0 AND t.id =b.idTable AND b.debt = N'Chưa Thanh Toán'";
                SqlCommand comsql = new SqlCommand(query, cnn); // thực thi các câu lệnh trong SQL
                SqlDataAdapter com = new SqlDataAdapter(comsql); // vận chuyển dữ liệu
                DataTable table = new DataTable(); // tạo 1 bảng ảo trong hệ thống
                com.Fill(table); // đổ dữ liệu vào bảng ảo
                dgvDept.DataSource = table; // bảng ảo được đổ vào datagrid
            }
            catch
            {
                MessageBox.Show("LỖI KẾT NỐI VUI LÒNG KIỂM TRA LẠI!!!");
            }
            finally
            {
                SqlConnection cnn = new SqlConnection(DataProvider.Instance.ConnectionString);
                cnn.Close();
            }
        }
        void UpdateCustomerToBill(string idBill, string customerName)
        {
            CustomerDAO.Instance.UpdateCustomerToBill(idBill, customerName);
        }
        void AddCustomer(string userName, string DisplayName, string Address, string number)
        {
            CustomerDAO.Instance.InsertGuess( DisplayName, Address, number);
        }
        void AddCustomToDebt()
        {
          dgvListBebt.DataSource=  CustomerDAO.Instance.ViewCustomer();
        }
        void UpdateTotalDebt(string id, int totalPrice)
        {
            BillDAO.Instance.UpdateToTalprice(id, totalPrice);
        }
        #endregion
        #region event
        public void dgvDept_SelectionChanged(object sender, EventArgs e)
        {
            try
            {
                try
                {
                    int vt = dgvDept.CurrentCell.RowIndex;
                    txtIdBillDept.Text = dgvDept.Rows[vt].Cells[0].Value.ToString().Trim();
                    txtIdBillDept.ReadOnly = true;
                    int totalDebt  = Convert.ToInt32(dgvDept.Rows[vt].Cells[3].Value.ToString().Trim());                 
                    txtDisCount.Text = dgvDept.Rows[vt].Cells[5].Value.ToString().Trim();
                    int disCount = int.Parse(txtDisCount.Text);
                    float totalPriceAfterDisount = totalDebt - (totalDebt * disCount / 100);
                    txtTotalDept.Text = totalPriceAfterDisount.ToString();
                    string idBill = dgvDept.Rows[vt].Cells[0].Value.ToString().Trim();                                      
                    try
                    {
                        string todate = tpToDate.Value.ToShortDateString();
                        SqlConnection cnn = new SqlConnection(DataProvider.Instance.ConnectionString);
                        cnn.Open();
                        string query = "SELECT f.name AS [Tên Món], bi.count AS [Số Lượng] FROM dbo.BillInfo AS bi, dbo.Food AS f WHERE bi.idFood = f.id AND bi.idBill IN (SELECT b.id FROM dbo.Bill AS b WHERE b.id = " + idBill + ")";
                        SqlCommand comsql = new SqlCommand(query, cnn); // thực thi các câu lệnh trong SQL
                        SqlDataAdapter com = new SqlDataAdapter(comsql); // vận chuyển dữ liệu
                        DataTable table = new DataTable(); // tạo 1 bảng ảo trong hệ thống
                        com.Fill(table); // đổ dữ liệu vào bảng ảo
                        dgvDeptInfo.DataSource = table; // bảng ảo được đổ vào datagrid
                    }
                    catch
                    {
                        MessageBox.Show("LỖI KẾT NỐI VUI LÒNG KIỂM TRA LẠI!!!");
                    }
                    finally
                    {
                        SqlConnection cnn = new SqlConnection(DataProvider.Instance.ConnectionString);
                        cnn.Close();
                    }

                }
                catch
                { }
            }

            catch
            { }
                
            
        }    
        private void bntViewBill_Click(object sender, EventArgs e)
        {
            LoadBill();
        }
        public void btnWrite_Click(object sender, EventArgs e)
        {
          
            if (txtDeptCustomer.Text == "" || txtAddressCustomer.Text == "" || txtPhoneDeptCustomer.Text == "")
            {
                MessageBox.Show("Các trường thông tin không được phép để trống!!!");
            }
            else
            {
                if (MessageBox.Show(("Bạn có muốn ghi hóa đơn nợ không???"), "Ghi Nợ", MessageBoxButtons.OKCancel) == System.Windows.Forms.DialogResult.OK)
                {
                    fReportDebt reprot = new fReportDebt();
                    reprot.temp = txtIdBillDept.Text;                  
                    reprot.totalPrice = float.Parse(txtTotalDept.Text);
                    reprot.ShowDialog();
                    string idBill = txtIdBillDept.Text;
                    string customerName = txtDeptCustomer.Text;
                    string address = txtAddressCustomer.Text;
                    string number = txtPhoneDeptCustomer.Text;
                    int TotalPrice = int.Parse(txtTotalDept.Text);
                    dgvDept.Controls.Clear();
                    AddCustomer(customerName, customerName, address, number);                   
                    UpdateCustomerToBill(idBill, customerName);
                    UpdateTotalDebt(idBill, TotalPrice);
                    debt = true;
                    AddCustomToDebt();
                }
                else
                {
                    string idBill = txtIdBillDept.Text;
                    string customerName = txtDeptCustomer.Text;
                    string address = txtAddressCustomer.Text;
                    string number = txtPhoneDeptCustomer.Text;
                    int TotalPrice = int.Parse(txtTotalDept.Text);
                    dgvDept.Controls.Clear();
                    AddCustomer(customerName, customerName, address, number);                    
                    UpdateCustomerToBill(idBill, customerName);
                    UpdateTotalDebt(idBill, TotalPrice);
                    debt = true;
                    AddCustomToDebt();
                } 
            }             
        }
        private void btnFinishDept_Click(object sender, EventArgs e)
        {
            int idBill = int.Parse(txtIdBillDept.Text);
            BillDAO.Instance.UpdateBillFinishDebt(idBill);
            AddCustomToDebt();
        }
        private void dgvListBebt_SelectionChanged(object sender, EventArgs e)
        {
            try
            {
                int vt = dgvListBebt.CurrentCell.RowIndex;
                int IdDebt = Convert.ToInt32(dgvListBebt.Rows[vt].Cells[1].Value.ToString().Trim());
            }
            catch
            {}

        }
       
        #endregion


    }
}
