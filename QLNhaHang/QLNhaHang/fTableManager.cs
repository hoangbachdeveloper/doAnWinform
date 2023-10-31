using QLNhaHang;
using System.IO;
using QLNhaHang.DAO;
using QLNhaHang.DTO;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using static QLNhaHang.fAccountProfile;

namespace QLNhaHang
{
    public partial class fTableManager : Form
    {
        private Account loginAccount;
        public Account LoginAccount
        {
            get
            {
                return loginAccount;
            }

            set
            {
                loginAccount = value;
                ChangeAcc(loginAccount.Type);
            }
        }
        public fTableManager(Account acc)
        {
            InitializeComponent();
            this.LoginAccount = acc;
            LoadTable();
            LoadCategory();
            //  LoadComboboxTable(cbSwitchTable);
        }
        #region method
        void UpdateTotalPriceForBill(int idBill, float toTalPrice)
        {
            BillDAO.Instance.UpdateTotalPrice(idBill, toTalPrice);
        }
        void ChangeAcc(int Type)
        {
            adminToolStripMenuItem.Enabled = Type == 1;
            thôngTinTàiKhoảnToolStripMenuItem.Text += " (" + LoginAccount.DisplayName + ")";
        }
        void LoadComboboxTable(ComboBox cb)
        {
            cb.DataSource = TableDAO.Instance.LoadTableList();
            cb.DisplayMember = "name";
        }
        void LoadCategory()
        {
            List<Category> listCategory = CategoryDAO.Instance.GetListCategory();
            cdCategory.DataSource = listCategory;
            cdCategory.DisplayMember = "name";
        }
        void LoadFoodByCategory(int id)
        {
            List<Food> listFood = FoodDAO.Instance.GetFoodByCategoryId(id);
            cbFood.DataSource = listFood;
            cbPrice.DataSource = listFood;
            cbFood.DisplayMember = "name";
            cbPrice.DisplayMember = "price";
        }
        public void LoadTable()
        {


            flowLayoutPanel1.Controls.Clear();
            List<Table> tablelist = TableDAO.Instance.LoadTableList();
            foreach (Table item in tablelist)
            {
                Button btn = new Button() { Width = TableDAO.TableWidth, Height = TableDAO.TableHeight };
                btn.Text = item.Name + Environment.NewLine + item.Status;
                btn.Click += Btn_Click1;
                btn.Tag = item;
                switch
                    (item.Status)
                {
                    case "Trống":
                        btn.BackColor = Color.Aqua;
                        break;
                    default:
                        btn.BackColor = Color.Lime;
                        break;
                }
                flowLayoutPanel1.Controls.Add(btn);
            }
        }
        private void Btn_Click1(object sender, EventArgs e)
        {
            int tableID = ((sender as Button).Tag as Table).ID;
            listView_Bill.Tag = (sender as Button).Tag;
            ShowBill(tableID);
            Table table = listView_Bill.Tag as Table;
            int idBill = BillDAO.Instance.GetUncheckBillIdByTableId(table.ID);
            SqlConnection cnn = new SqlConnection(DataProvider.Instance.ConnectionString);
            DataTable da = new DataTable(); // tạo 1 bảng ảo trong hệ thống
            cnn.Open();
            SqlDataAdapter com = new SqlDataAdapter("SELECT name FROM dbo.TableFood WHERE id = " + tableID, cnn); // vận chuyển dữ liệu       
            com.Fill(da); // đổ dữ liệu vào bảng ảo
            cbDisPlayNameTable.DataSource = da; // bảng ảo được đổ vào datagrid
            cbDisPlayNameTable.DisplayMember = "name";
            cnn.Close();
        }
        void ShowBill(int id)
        {
            listView_Bill.Items.Clear();
            List<DTO.Menu> listBillInfo = MenuDAO.Instance.GetListMenuByTable(id);
            float totalPrice = 0;
            foreach (DTO.Menu item in listBillInfo)
            {
                ListViewItem lsvItem = new ListViewItem(item.FoodName.ToString());
                lsvItem.SubItems.Add(item.Count.ToString());
                lsvItem.SubItems.Add(item.Price.ToString());
                lsvItem.SubItems.Add(item.TotalPrice.ToString());
                totalPrice += item.TotalPrice;
                listView_Bill.Items.Add(lsvItem);
            }
            txttotalPrice.Text = totalPrice.ToString();
            //LoadTable();
        }
        #endregion

        #region event        
        private void đăngXuấtToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.Close();
        }
        private void thôngTinCáNhânToolStripMenuItem_Click(object sender, EventArgs e)
        {
            fAccountProfile f = new fAccountProfile(loginAccount);
            f.UpdateAccount += F_UpdateAccount;
            f.Show();
        }
        private void F_UpdateAccount(object sender, AccountEven e)
        {
            thôngTinTàiKhoảnToolStripMenuItem.Text = "Thông Tin Tài Khoản (" + e.Acc.DisplayName + ")";
        }
        private void adminToolStripMenuItem_Click(object sender, EventArgs e)
        {
            fAdmin f = new fAdmin();
            f.loginAccount = LoginAccount;
            f.InsertFood += F_InsertFood;
            f.DeleteFood += F_DeleteFood;
            f.UpdateFood += F_UpdateFood;
            f.ShowDialog();
            LoadTable();
            LoadCategory();
        }
        private void F_UpdateFood(object sender, EventArgs e)
        {
            LoadFoodByCategory((cdCategory.SelectedItem as Category).ID);
            if (listView_Bill.Tag != null)
                ShowBill((listView_Bill.Tag as Table).ID);
            LoadTable();
        }
        private void F_DeleteFood(object sender, EventArgs e)
        {
            LoadFoodByCategory((cdCategory.SelectedItem as Category).ID);
            if (listView_Bill.Tag != null)
                ShowBill((listView_Bill.Tag as Table).ID);
            LoadTable();
        }
        private void F_InsertFood(object sender, EventArgs e)
        {
            LoadFoodByCategory((cdCategory.SelectedItem as Category).ID);
            if (listView_Bill.Tag != null)
                ShowBill((listView_Bill.Tag as Table).ID);
            LoadTable();
        }
        private void cdCategory_SelectedIndexChanged(object sender, EventArgs e)
        {
            int id = 0;
            ComboBox cb = sender as ComboBox;
            if (cb.SelectedItem == null)
                return;
            Category selected = cb.SelectedItem as Category;
            id = selected.ID;
            LoadFoodByCategory(id);
        }
        private void btnAddFood_Click(object sender, EventArgs e)
        {
            Table table = listView_Bill.Tag as Table;
            if (table == null)
            {
                MessageBox.Show("Hãy chọn bàn");
                return;
            }

            if ((int)nmAddFood.Value != 0)
            {


                int idBill = BillDAO.Instance.GetUncheckBillIdByTableId(table.ID);
                int foodID = (cbFood.SelectedItem as Food).ID;
                int count = (int)nmAddFood.Value;

                if (idBill == -1)
                {
                    BillDAO.Instance.InsertBill(table.ID);
                    //MessageBox.Show(table.ID.ToString());
                    BillInforDAO.Instance.InserBillInfor(BillDAO.Instance.GetMaxIdBill(), foodID, count);
                    LoadTable();
                    ShowBill(table.ID);

                }
                else
                {
                    BillInforDAO.Instance.InserBillInfor(idBill, foodID, count);
                    ShowBill(table.ID);
                    float totalPrice = float.Parse(txttotalPrice.Text);
                    BillDAO.Instance.UpdateBill(idBill, totalPrice);
                    LoadTable();

                }
                //float toTalPrices = float.Parse(txttotalPrice.Text);
                //MessageBox.Show(idBill.ToString());             
                //UpdateTotalPriceForBill(idBill,toTalPrices);

            }
            else
            {
                MessageBox.Show("Hãy Chọn Số Lượng Món Ăn!!!");
            }
            nmAddFood.Value = 0;
        }
        private void btnCheckOut_Click(object sender, EventArgs e)
        {
            Table table = listView_Bill.Tag as Table;
            if (table == null)
            {
                MessageBox.Show("Hãy chọn bàn");
                return;
            }
            if (MessageBox.Show(("Bạn có muốn in hóa đơn không???"), "In Hóa Đơn", MessageBoxButtons.OKCancel) == System.Windows.Forms.DialogResult.OK)
            {
                int idBill = BillDAO.Instance.GetUncheckBillIdByTableId(table.ID);
                int discount = (int)nmDisCount.Value;
                float money = float.Parse(txttotalPrice.Text);
                float TotalPrice = money - (money * discount) / 100;
                if (idBill != -1)
                {
                    fReportForCheckOut reprot = new fReportForCheckOut();
                    reprot.temp = idBill.ToString();
                    reprot.totalPrice = TotalPrice;
                    reprot.ShowDialog();
                    BillDAO.Instance.CheckOutBillId(idBill, money, discount);
                    ShowBill(table.ID);
                    LoadTable();
                    nmDisCount.Value = 0;
                }
                else
                {
                    if (MessageBox.Show(("Bạn có chắc muốn thanh toán hóa đơn cho " + table.Name + "\n " + "Tổng thanh toán:\n " + TotalPrice) + "VND", "THANH TOÁN", MessageBoxButtons.OKCancel) == System.Windows.Forms.DialogResult.OK)
                    {
                        BillDAO.Instance.CheckOutBillId(idBill, money, discount);
                        ShowBill(table.ID);
                        LoadTable();
                        nmDisCount.Value = 0;
                    }
                }

                //reprot.temp = txtIdBillDept.Text;

            }
            else
            {
                int idBill = BillDAO.Instance.GetUncheckBillIdByTableId(table.ID);
                int discount = (int)nmDisCount.Value;
                float money = float.Parse(txttotalPrice.Text);
                float TotalPrice = money - (money * discount) / 100;
                if (idBill != -1)
                {
                    if (MessageBox.Show(("Bạn có chắc muốn thanh toán hóa đơn cho " + table.Name + "\n " + "Tổng thanh toán:\n " + TotalPrice) + "VND", "THANH TOÁN", MessageBoxButtons.OKCancel) == System.Windows.Forms.DialogResult.OK)
                    {
                        BillDAO.Instance.CheckOutBillId(idBill, money, discount);
                        ShowBill(table.ID);
                        LoadTable();
                        nmDisCount.Value = 0;
                    }
                }
            }
        }
        //private void btnSwitchTable_Click(object sender, EventArgs e)
        //{            
        //    int id1 = (listView_Bill.Tag as Table).ID;
        //    int id2 = (cbSwitchTable.SelectedItem as Table).ID;
        //    if (MessageBox.Show(string.Format("Bạn có thật sự muốn chuyển từ {0} qua {1} hay không???", (listView_Bill.Tag as Table).Name, (cbSwitchTable.SelectedItem as Table).Name),"Thông Báo...", MessageBoxButtons.OKCancel) == System.Windows.Forms.DialogResult.OK)
        //    {
        //        TableDAO.Instance.SwitchTable(id1, id2);
        //        LoadTable();
        //    }            
        //}
        private void thanhToánToolStripMenuItem_Click(object sender, EventArgs e)
        {
            btnCheckOut_Click(this, new EventArgs());
        }
        private void thêmMónToolStripMenuItem_Click(object sender, EventArgs e)
        {
            btnAddFood_Click(this, new EventArgs());
        }
        //private void chuyểnBànToolStripMenuItem_Click(object sender, EventArgs e)
        //{
        //    btnSwitchTable_Click(this, new EventArgs());
        //}
        private void btnDebt_Click(object sender, EventArgs e)
        {
            Table table = listView_Bill.Tag as Table;
            if (table == null)
            {
                MessageBox.Show("Hãy chọn bàn");
                return;
            }
            int discount = (int)nmDisCount.Value;
            int idBill = BillDAO.Instance.GetUncheckBillIdByTableId(table.ID);
            BillDAO.Instance.UpdateDisCount(idBill, discount);
            fDebt debt = new fDebt();
            debt.ShowDialog();
            if (debt.debt)
            {
                BillDAO.Instance.UpdateBillDisCount(idBill);
            }
            else
            {

            }
            listView_Bill.Clear();
            LoadTable();

        }       
        private void btnCheckOut_Click_1(object sender, EventArgs e)
        {
            Table table = listView_Bill.Tag as Table;
            if (table == null)
            {
                MessageBox.Show("Hãy chọn bàn");
                return;
            }
            if (MessageBox.Show(("Bạn có muốn in hóa đơn không???"), "In Hóa Đơn", MessageBoxButtons.OKCancel) == System.Windows.Forms.DialogResult.OK)
            {
                int idBill = BillDAO.Instance.GetUncheckBillIdByTableId(table.ID);
                int discount = (int)nmDisCount.Value;
                float money = float.Parse(txttotalPrice.Text);
                float TotalPrice = money - (money * discount) / 100;
                if (idBill != -1)
                {
                    fReportForCheckOut reprot = new fReportForCheckOut();
                    reprot.temp = idBill.ToString();
                    reprot.totalPrice = TotalPrice;
                    reprot.ShowDialog();
                    BillDAO.Instance.CheckOutBillId(idBill, money, discount);
                    ShowBill(table.ID);
                    LoadTable();
                    nmDisCount.Value = 0;
                }
            }
            else
            {
                int idBill = BillDAO.Instance.GetUncheckBillIdByTableId(table.ID);
                int discount = (int)nmDisCount.Value;
                float money = float.Parse(txttotalPrice.Text);
                float TotalPrice = money - (money * discount) / 100;
                if (MessageBox.Show(("Bạn có chắc muốn thanh toán hóa đơn cho " + table.Name + "\n " + "Tổng thanh toán:\n " + TotalPrice) + "VND", "THANH TOÁN", MessageBoxButtons.OKCancel) == System.Windows.Forms.DialogResult.OK)
                {

                    if (idBill != -1)
                    {
                        BillDAO.Instance.CheckOutBillId(idBill, money, discount);
                        ShowBill(table.ID);
                        LoadTable();
                        nmDisCount.Value = 0;
                    }
                }
            }
        }
        private void btnDept_Click(object sender, EventArgs e)
        {

            Table table = listView_Bill.Tag as Table;
            if (table == null)
            {
                MessageBox.Show("Hãy chọn bàn");
                return;
            }
            int discount = (int)nmDisCount.Value;
            int idBill = BillDAO.Instance.GetUncheckBillIdByTableId(table.ID);
            BillDAO.Instance.UpdateDisCount(idBill, discount);
            fDebt debt = new fDebt();
            debt.ShowDialog();
            if (debt.debt)
            {
                BillDAO.Instance.UpdateBillDisCount(idBill);
            }
            else
            {

            }
            // listView_Bill.Clear();
            LoadTable();
        }
        private void pictureBox1_Click(object sender, EventArgs e)
        {
            fHelp f = new fHelp();
            f.ShowDialog();
        }
        #endregion
        private void trợGiúpToolStripMenuItem_Click(object sender, EventArgs e)
        {
            pictureBox1_Click(this, new EventArgs());
        }     
        private void ghiNợToolStripMenuItem_Click(object sender, EventArgs e)
        {
            btnDebt_Click(this, new EventArgs());
        }
    }
}
