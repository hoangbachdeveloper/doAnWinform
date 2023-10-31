using QLNhaHang.DAO;
using QLNhaHang.DTO;
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

namespace QLNhaHang
{
    public partial class flogin : Form
    {
        public flogin()
        {
            InitializeComponent();
        }
        #region method
       public bool Login(string userName, string passWord)
        {        
            return AccountDAO.Instance.Login(userName, passWord);
        }
        #endregion
        private void btnlogin_Click(object sender, EventArgs e)
        {
            string userName = txtUserName.Text;
            string passWord = txtPassWord.Text;
            if (Login(userName, passWord))
            {
                Account loginAccount = AccountDAO.Instance.GetAccountByUserName(userName);             
                fTableManager f = new fTableManager(loginAccount);
                this.Hide();
                f.ShowDialog();
                this.Show();
            }
            else
            {
                MessageBox.Show("Sai Tên Đăng Nhập hoặc Mật Khẩu!!!");
            }
        }

        private void flogin_Load(object sender, EventArgs e)
        {
            txtUserName.Focus();
        }
    }
}
