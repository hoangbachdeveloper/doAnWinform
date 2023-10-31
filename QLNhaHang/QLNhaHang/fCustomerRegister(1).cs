using QLNhaHang.DAO;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QLNhaHang
{
    public partial class fCustomerRegister : Form
    {
        public fCustomerRegister()
        {
            InitializeComponent();
        }
        #region
        fAdmin fAdmin = new fAdmin();
        void AddGuess(string userName, string DisplayName, string address, string number)
        {
            if (CustomerDAO.Instance.InsertGuess(userName, DisplayName, address, number))
            {
                MessageBox.Show("Thêm Tài Khoản Khách Hàng Thành Công!!!");
            }
            else
                MessageBox.Show("Thêm Tài Khoản Khách Hàng Thất Bại!!!");
            fAdmin.LoadGues();
        }
        void UpdateGuess(string userName, string DisplayName, string address, string number)
        {
            if (CustomerDAO.Instance.UpdateGuess(DisplayName, address, number, userName))
            {
                MessageBox.Show("Cập Nhật Tài Khoản Khách Hàng Thành Công!!!");
            }
            else
                MessageBox.Show("Cập Nhật Tài Khoản Khách Hàng Thất Bại!!!");
            fAdmin.LoadGues();
        }
        #endregion
        #region event

        private void buttonX1_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btnAddCustomer_Click(object sender, EventArgs e)
        {
            string userName = txtUserNameOfGues.Text;
            string DisplayName = txtDisplayNameOfGues.Text;
            string address = txtAddressOfGuess.Text;
            string number = txtNumberOfGuess.Text;
            if (txtUserNameOfGues.Text == "" && txtDisplayNameOfGues.Text == "" && txtAddressOfGuess.Text == "" && txtNumberOfGuess.Text == "")
            {
                MessageBox.Show("Vui Lòng Không Để Trống Các Trường Đang Hiển Thị");
            }
            else
            {
                AddGuess(userName, DisplayName, address, number);
            }
            
        }

        private void btnEditCustomer_Click(object sender, EventArgs e)
        {
            string DisplayName = txtDisplayNameOfGues.Text;  
            string address = txtAddressOfGuess.Text;
            string number = txtNumberOfGuess.Text;
            string userName = txtUserNameOfGues.Text;
            UpdateGuess(DisplayName, address, number, userName);
        }
        #endregion
    }
}
