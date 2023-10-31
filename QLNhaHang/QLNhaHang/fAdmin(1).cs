using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.IO;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;
using QLNhaHang.DAO;
using QLNhaHang.DTO;

namespace QLNhaHang
{
    public partial class fAdmin : Form
    {
        public fAdmin()
        {
            InitializeComponent();      
            Load_Datime();      
            LoadListFood();
            LoadLisstBillByDate();
            Load_CategoryToCb(cbCategoryFood);
            LoadListAcc();
            LoadCategory();
            LoadGues();
            LoadTable(); 
        }
        public  SqlConnection cnn = new SqlConnection(DataProvider.Instance.ConnectionString);
        #region method
        public Account loginAccount;
        public void LoadGues()
        {
            dgvCustomer.DataSource = CustomerDAO.Instance.GetGuess();
        }
        void LoadCategory()
        {
            try
            {           
                SqlConnection cnn = new SqlConnection(DataProvider.Instance.ConnectionString);
                cnn.Open();
                string query = "SELECT id AS [Mã Danh Mục], name AS [Tên Danh Mục]  FROM dbo.FoodCategory";
                SqlCommand comsql = new SqlCommand(query, cnn); // thực thi các câu lệnh trong SQL
                SqlDataAdapter com = new SqlDataAdapter(comsql); // vận chuyển dữ liệu
                DataTable table = new DataTable(); // tạo 1 bảng ảo trong hệ thống
                com.Fill(table); // đổ dữ liệu vào bảng ảo
                dgvCategory.DataSource = table; // bảng ảo được đổ vào datagrid
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
        void LoadListFood()
        {
            try
            {
                //string fromdate = tpFromDate.Value.ToShortDateString();
                //string todate = tpToDate.Value.ToShortDateString();
                SqlConnection cnn = new SqlConnection(DataProvider.Instance.ConnectionString);
                cnn.Open();
                string query = "SELECT  f.id as [Mã Món], f.name AS [Tên Món], fc.name AS [Danh Mục], f.price AS [Đơn Giá]  FROM Food AS f, dbo.FoodCategory AS fc WHERE f.idCategory = fc.id";
                SqlCommand comsql = new SqlCommand(query, cnn); // thực thi các câu lệnh trong SQL
                SqlDataAdapter com = new SqlDataAdapter(comsql); // vận chuyển dữ liệu
                DataTable table = new DataTable(); // tạo 1 bảng ảo trong hệ thống
                com.Fill(table); // đổ dữ liệu vào bảng ảo
                dgvFood.DataSource = table; // bảng ảo được đổ vào datagrid
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
        void Load_CategoryToCb(ComboBox cb)
        {
            List<Category> listCategory = CategoryDAO.Instance.GetListCategory();
            cb.DataSource = listCategory;
            cb.DisplayMember = "name";
        }     
        void LoadTable()
        {
            dgvTableFoods.DataSource = TableDAO.Instance.GetListTable();
        }
        void Load_Datime()
        {
            DateTime today = DateTime.Now;
            tpFromDate.Value = new DateTime(today.Year, today.Month, 1);
            tpToDate.Value = new DateTime(today.Year, today.Month, 1).AddMonths(1).AddDays(-1);
        }
        void LoadLisstBillByDate()
        {
            //try { 
            string fromdate = tpFromDate.Value.ToShortDateString();
            string todate = tpToDate.Value.ToShortDateString();
            //MessageBox.Show("Ngày vào: " + fromdate.ToString());
            // MessageBox.Show("Ngày ra: " + todate.ToString());
            SqlConnection cnn = new SqlConnection(DataProvider.Instance.ConnectionString);
            cnn.Open();
            string query = "SELECT t.name AS [Tên bàn], b.totalPrice AS [Tổng tiền], DateCheckIn AS [Ngày vào], DateCheckOut AS [Ngày ra], discount AS [Giảm giá] FROM dbo.Bill AS b,dbo.TableFood AS t WHERE DateCheckIn >='" + fromdate + "' AND DateCheckOut <= '" + todate + "' AND b.status = 1 AND t.id = b.idTable";
            SqlCommand comsql = new SqlCommand(query, cnn); // thực thi các câu lệnh trong SQL
            SqlDataAdapter com = new SqlDataAdapter(comsql); // vận chuyển dữ liệu
            DataTable table = new DataTable(); // tạo 1 bảng ảo trong hệ thống
            com.Fill(table); // đổ dữ liệu vào bảng ảo
            dgvBill.DataSource = table; // bảng ảo được đổ vào datagrid
            //}
            //catch
            //{
            //    MessageBox.Show("LỖI KẾT NỐI VUI LÒNG KIỂM TRA LẠI!!!");
            //}
            //finally
            //{
            //   // SqlConnection cnn = new SqlConnection(Connection.connectionString);
                cnn.Close();
            //}
           
        }
        void LoadListAcc()
        {
            dgvAccount.DataSource = AccountDAO.Instance.GetListAcc();
        }       
        void SearchFood()
        {
            try { 
            SqlConnection cnn = new SqlConnection(DataProvider.Instance.ConnectionString);
            cnn.Open();
            string query = "SELECT f.id as [Mã Món], f.name AS [Tên Món], fc.name AS [Danh Mục], f.price AS [Đơn Giá] FROM dbo.Food AS f, dbo.FoodCategory AS fc WHERE f.idCategory = fc.id AND dbo.utf8ConvertSQL(f.name) LIKE N'%' + dbo.utf8ConvertSQL(N'" + txtSearchFood.Text + "') + '%'";    
            SqlCommand comsql = new SqlCommand(query, cnn); // thực thi các câu lệnh trong SQL
            SqlDataAdapter com = new SqlDataAdapter(comsql); // vận chuyển dữ liệu
            DataTable table = new DataTable(); // tạo 1 bảng ảo trong hệ thống
            com.Fill(table); // đổ dữ liệu vào bảng ảo
            dgvFood.DataSource = table; // bảng ảo được đổ vào datagrid
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
        int accountType;
        void GetTotalPriceByDate()
        {
            string fromdate = tpFromDate.Value.ToShortDateString();
            string todate = tpToDate.Value.ToShortDateString();         
            SqlConnection cnn = new SqlConnection(DataProvider.Instance.ConnectionString);
            DataTable da = new DataTable(); // tạo 1 bảng ảo trong hệ thống
            cnn.Open();
            SqlDataAdapter com = new SqlDataAdapter("SELECT SUM (totalPrice) FROM dbo.Bill WHERE DateCheckIn >='" + fromdate + "' AND DateCheckOut <= '" + todate + "'", cnn); // vận chuyển dữ liệu       
            com.Fill(da); // đổ dữ liệu vào bảng ảo
            cbTotalPrice.DataSource = da; // bảng ảo được đổ vào datagrid
            cbTotalPrice.DisplayMember = "column1";
            cnn.Close();
        }
        void AddAccount(string UserName, string DisPlayName, int Type, string AccType)
        {


            if (AccountDAO.Instance.InsertAccount(UserName, DisPlayName, Type, AccType))
            {
                MessageBox.Show("Thêm Tài Khoản Thành Công!!!");
            }
            else
                MessageBox.Show("Thêm Tài Khoản Thất Bại!!!");
            LoadListAcc();

        }
        void UpdateAccount(string UserName, string DisPlayName, int Type, string AccType)
        {
            if (AccountDAO.Instance.UpdateAcc(UserName, DisPlayName, Type, AccType))
            {
                MessageBox.Show("Cập Nhật Tài Khoản Thành Công!!!");
            }
            else
                MessageBox.Show("Cập Nhật Tài Khoản Thất Bại!!!");
            LoadListAcc();
        }
        void DeleteAccount(string id)
        {
            if (loginAccount.UserName.Equals(id))
            {
                MessageBox.Show("Vui Lòng Không Xóa Tài Khoản Hiện Tại!!!");
                return;
            }
            if (AccountDAO.Instance.DeleteAccount(id))
            {
                MessageBox.Show("Xóa Tài Khoản Thành Công!!!");
            }
            else
                MessageBox.Show("Xóa Tài Khoản Thất Bại!!!");
            LoadListAcc();

        }
        void ResetPass(string userName)
        {
            if (AccountDAO.Instance.ResetPass(userName))
            {
                MessageBox.Show("Cập Nhật Mật Khẩu Thành Công!!! \n Mật Khẩu Mới Của Bạn là 0000 !!! \n Vui Lòng Đặt Lại Mật Khẩu Mới Của Bạn Để Tránh Bị Lộ Thông Tin!!! ");
            }
            else
                MessageBox.Show("Cập Nhật Mật Khẩu Thất Bại!!!");
            LoadListAcc();
        }
        void ResetPassCustomer(string userName)
        {
            if (CustomerDAO.Instance.ResetPass(userName))
            {
                MessageBox.Show("Cập Nhật Mật Khẩu Thành Công!!! \n Mật Khẩu Mới Của Bạn là 0000 !!! \n Vui Lòng Đặt Lại Mật Khẩu Mới Của Bạn Để Tránh Bị Lộ Thông Tin!!! ");
            }
            else
                MessageBox.Show("Cập Nhật Mật Khẩu Thất Bại!!!");
            LoadListAcc();
        }
        void DeleteCustomer(string userName)
        {
            if (CustomerDAO.Instance.DeleteGuess(userName))
            {
                MessageBox.Show("Xóa Khách Nợ Thành Công!!!");
            }
            else
                MessageBox.Show("Xóa Khách Nợ Thất Bại!!!");
            LoadGues();
        }
        #endregion
        /* ==============================================================================================*/
        #region event
              
        private event EventHandler insertFood;
        public event EventHandler InsertFood
        {
            add { insertFood += value; }
            remove { insertFood -= value; }
        }
        private event EventHandler updateFood;
        public event EventHandler UpdateFood
        {
            add { updateFood += value; }
            remove { updateFood -= value; }
        }
        private event EventHandler deleteFood;
        public event EventHandler DeleteFood
        {
            add { deleteFood += value; }
            remove { deleteFood -= value; }
        }
        private event EventHandler insertCategory;
        public event EventHandler  InsertCategory
        {
            add { insertCategory += value; }
            remove { insertCategory -= value; }
        }
        private event EventHandler updateCategory;
        public event EventHandler UpdateCategory
        {
            add { updateCategory += value; }
            remove { updateCategory -= value; }
        }
        private event EventHandler deleteCategory;
        public event EventHandler DeleteCategory
        {
            add { deleteCategory += value; }
            remove { deleteCategory -= value; }
        }              
        private void dgvDept_SelectionChanged(object sender, EventArgs e)
        {

        }
        private void dgvGues_SelectionChanged(object sender, EventArgs e)
        {
            
        }
        private void dgvTableFood_SelectionChanged(object sender, EventArgs e)
        {
            try
            {
                int vt = dgvTableFood.CurrentCell.RowIndex;
                txtIdTable.Text = dgvTableFood.Rows[vt].Cells[0].Value.ToString().Trim();
                txtTableName.Text = dgvTableFood.Rows[vt].Cells[1].Value.ToString().Trim();
                cbStatusTable.Text = dgvTableFood.Rows[vt].Cells[2].Value.ToString().Trim();
            }
            catch { }
        }      
        private void btnViewTables_Click(object sender, EventArgs e)
        {
            LoadTable();
        }
        private void btnAddTables_Click(object sender, EventArgs e)
        {
            string name = txtTablesName.Text;
            if (TableDAO.Instance.InsertTable(name))
            {
                MessageBox.Show("Thêm Bàn Thành Công!");
                LoadTable();
            }
            else
            {
                MessageBox.Show("Thêm Bàn Không Thành Công!");
            }
        }
        private void btnEditTables_Click(object sender, EventArgs e)
        {
            string name = txtTablesName.Text;
            string id = txtTableID.Text;
            if (TableDAO.Instance.UpdateTable(name, id))
            {
                MessageBox.Show("Cập Nhật Bàn Thành Công!");
                LoadTable();
            }
            else
            {
                MessageBox.Show("Cập Nhật Bàn Không Thành Công!");
            }
        }
        private void btnDeleteTables_Click(object sender, EventArgs e)
        {
            string name = txtTablesName.Text;
            int id = int.Parse(txtTableID.Text);
            if (TableDAO.Instance.DeleteTable(id))
            {
                MessageBox.Show("Xóa Bàn Thành Công!");
                LoadTable();
            }
            else
            {
                MessageBox.Show("Xóa Bàn Không Thành Công!");
            }
        }        
        private void dgvTableFoods_SelectionChanged(object sender, EventArgs e)
        {
            try
            {
                int vt = dgvTableFoods.CurrentCell.RowIndex;
                txtTableID.Text = dgvTableFoods.Rows[vt].Cells[0].Value.ToString().Trim();
                txtTablesName.Text = dgvTableFoods.Rows[vt].Cells[1].Value.ToString().Trim();
                cbTableStatus.Text = dgvTableFoods.Rows[vt].Cells[2].Value.ToString().Trim();
            }
            catch { }
        }
        private void btnViewBill_Click_1(object sender, EventArgs e)
        {
            LoadLisstBillByDate();
            GetTotalPriceByDate();
        }
        private void btnDeleteFood_Click_1(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(txtIdFood.Text);
            string name = txtNameFood.Text;
            int categoryID = (cbCategoryFood.SelectedItem as Category).ID;
            float price = (float)nmFoodPrice.Value;
            if (FoodDAO.Instance.DeleteFood(id))
            {
                MessageBox.Show("Xóa Món Thành Công!");
                LoadListFood();
                if (deleteFood != null)
                    deleteFood(this, new EventArgs());
            }
            else
                MessageBox.Show("Xóa Món Không Thành Công!");
        }
        private void btnUpdateFood_Click_1(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(txtIdFood.Text);
            string name = txtNameFood.Text;
            int categoryID = (cbCategoryFood.SelectedItem as Category).ID;
            float price = (float)nmFoodPrice.Value;
            if (FoodDAO.Instance.UpdateFood(id, name, categoryID, price))
            {
                MessageBox.Show("Sửa Món Thành Công!");
                LoadListFood();
                if (updateFood != null)
                    updateFood(this, new EventArgs());
            }
            else
                MessageBox.Show("Sửa Món Không Thành Công!");
        }
        private void btnAddFood_Click_1(object sender, EventArgs e)
        {
            string name = txtNameFood.Text;
            int categoryID = (cbCategoryFood.SelectedItem as Category).ID;
            float price = (float)nmFoodPrice.Value;
            if (FoodDAO.Instance.InsertFood(name, categoryID, price))
            {
                MessageBox.Show("Thêm Món Thành Công!");
                LoadListFood();
                if (insertFood != null)

                {
                    insertFood(this, new EventArgs());
                }
            }
            else
            {
                MessageBox.Show("Thêm Món Không Thành Công!");
            }
        }
        private void btnSearchFood_Click_1(object sender, EventArgs e)
        {
            SearchFood();
        }
        private void btnShowFood_Click_1(object sender, EventArgs e)
        {
            LoadListFood();
        }
        private void dgvFood_SelectionChanged(object sender, EventArgs e)
        {
            try
            {
                int vt = dgvFood.CurrentCell.RowIndex;
                txtIdFood.Text = dgvFood.Rows[vt].Cells[0].Value.ToString().Trim();
                txtIdFood.ReadOnly = true;
                txtNameFood.Text = dgvFood.Rows[vt].Cells[1].Value.ToString().Trim();
                cbCategoryFood.Text = dgvFood.Rows[vt].Cells[2].Value.ToString().Trim();
                nmFoodPrice.Text = dgvFood.Rows[vt].Cells[3].Value.ToString().Trim();
            }
            catch
            { }
        }
        private void btnAddCategory_Click_1(object sender, EventArgs e)
        {
            string nameCategory = txtNameCategory.Text;
            if (CategoryDAO.Instance.InsertCategory(nameCategory))
            {
                MessageBox.Show("Thêm Danh Mục Thành Công!");
                LoadCategory();
                if (insertCategory != null)
                {
                    updateCategory(this, new EventArgs());
                }
            }
            else
            {
                MessageBox.Show("Thêm Danh Mục Không Thành Công!");
            }
        }
        private void btnEditCategory_Click_1(object sender, EventArgs e)
        {
            int idCategory = int.Parse(txtIdCategory.Text);
            string nameCategory = txtNameCategory.Text;
            if (CategoryDAO.Instance.UpdateCategory(idCategory, nameCategory))
            {
                MessageBox.Show("Cập Nhật Danh Mục Thành Công!");
                LoadCategory();
                if (updateCategory != null)
                {
                    updateCategory(this, new EventArgs());
                }
            }
            else
            {
                MessageBox.Show("Cập Nhật Danh Mục Không Thành Công!");
            }
        }
        private void btnDeleteCategory_Click_1(object sender, EventArgs e)
        {
            int idCategory = int.Parse(txtIdCategory.Text);
            string nameCategory = txtNameCategory.Text;
            int countFodd = CategoryDAO.Instance.DeleteCategory(idCategory);
            if (countFodd > 0)
            {
                if (countFodd > 0)
                {
                    MessageBox.Show("Xóa Danh Mục Thành Công!");
                    LoadCategory();
                    if (deleteCategory != null)
                    {
                        deleteCategory(this, new EventArgs());
                    }
                }
                else
                {
                    MessageBox.Show("Xóa Danh Mục Không Thành Công!");
                }
            }
            else
            {
                MessageBox.Show("Đang tồn tại danh sách đồ ăn trong Danh Mục " + nameCategory + "\n Hãy xóa đồ ăn trong danh mục này trước!");
            }
        }
        private void btnShowCategory_Click(object sender, EventArgs e)
        {
            Load_CategoryToCb(cbCategoryFood);
        }
        private void dgvCategory_SelectionChanged_1(object sender, EventArgs e)
        {
            try
            {
                int vt = dgvCategory.CurrentCell.RowIndex;
                txtIdCategory.Text = dgvCategory.Rows[vt].Cells[0].Value.ToString().Trim();
                txtNameCategory.Text = dgvCategory.Rows[vt].Cells[1].Value.ToString().Trim();
                txtIdCategory.Enabled = false;
            }
            catch
            { }
        }
        private void btnAddAccount_Click_1(object sender, EventArgs e)
        {
            string userName = txtUserName.Text;
            string disPlayName = txtDisPlayName.Text;
            string accType = cbTypeAcc.Text;
            AddAccount(userName, disPlayName, accountType, accType);
        }
        private void btnEditAccount_Click_1(object sender, EventArgs e)
        {
            string userName = txtUserName.Text;
            string disPlayName = txtDisPlayName.Text;
            string accType = cbTypeAcc.Text;
            UpdateAccount(userName, disPlayName, accountType, accType);
        }
        private void btnDeleteAccount_Click_1(object sender, EventArgs e)
        {
            string userName = txtUserName.Text;
            DeleteAccount(userName);
        }
        private void btnShowAccount_Click(object sender, EventArgs e)
        {
            LoadListAcc();
        }
        private void dgvAccount_SelectionChanged_1(object sender, EventArgs e)
        {
            try
            {
                int vt = dgvAccount.CurrentCell.RowIndex;
                txtUserName.Text = dgvAccount.Rows[vt].Cells[0].Value.ToString().Trim();
                txtDisPlayName.Text = dgvAccount.Rows[vt].Cells[1].Value.ToString().Trim();
                cbTypeAcc.Text = dgvAccount.Rows[vt].Cells[2].Value.ToString().Trim();
                // nmFoodPrice.Text = dgvFood.Rows[vt].Cells[3].Value.ToString().Trim();
            }
            catch
            { }
        }
        private void btn_ResetPass_Click(object sender, EventArgs e)
        {
            string userName = txtUserName.Text;
            ResetPass(userName);
        }
        private void cbTypeAcc_SelectedIndexChanged_1(object sender, EventArgs e)
        {
            if (cbTypeAcc.SelectedIndex == 0)
                accountType = 1;
            if (cbTypeAcc.SelectedIndex == 1)
                accountType = 0;
        }
        private void btnShowCustomer_Click_1(object sender, EventArgs e)
        {
            dgvCustomer.DataSource = CustomerDAO.Instance.GetGuess();
        }
        private void btnDeleteCustomer_Click_1(object sender, EventArgs e)
        {
            string userName = txtUserNameOfCustomer.Text;
            DeleteCustomer(userName);
        }
        private void dgvCustomer_SelectionChanged(object sender, EventArgs e)
        {
            try
            {
                int vt = dgvCustomer.CurrentCell.RowIndex;
                txtUserNameOfCustomer.Text = dgvCustomer.Rows[vt].Cells[0].Value.ToString().Trim();
                txtDisplayNameOfCustomer.Text = dgvCustomer.Rows[vt].Cells[1].Value.ToString().Trim();
                txtAddressOfCustomer.Text = dgvCustomer.Rows[vt].Cells[3].Value.ToString().Trim();
                txtNumberOfCustomer.Text = dgvCustomer.Rows[vt].Cells[2].Value.ToString().Trim();
                //txtDateCheckOut.Text = Convert.ToString(dgvCustomer.Rows[vt].Cells[4].Value.ToString().Trim()).ToString();
                txtUserNameOfCustomer.Enabled = false;
            }
            catch
            { }
        }
        #endregion
    }
}
