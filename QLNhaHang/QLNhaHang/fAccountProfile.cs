using QLNhaHang.DAO;
using QLNhaHang.DTO;
using System;
using System.IO;
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
    public partial class fAccountProfile : Form
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
                ChangeAccount(loginAccount);
            }
        }
        public fAccountProfile(Account acc)
        {
            InitializeComponent();
            LoginAccount = acc;
        }
        #region method

        void ChangeAccount(Account acc)
        {
            txttendangnhap.Text = LoginAccount.UserName;
            txttenhienthi.Text = LoginAccount.DisplayName;
        }
        void UpdateAccountInfo()
        {
            string disPlayName = txttenhienthi.Text;
            string password = txtmatkhau.Text;
            string newpass = txtmatkhaumoi.Text;
            string username = txttendangnhap.Text;
            string reenterpass = txtnhaplai.Text;
            if (!newpass.Equals(reenterpass))
            {
                MessageBox.Show("Vui lòng nhập lại mật khẩu mới!");
            }
            else
            {
                if (AccountDAO.Instance.UpdateAccount(disPlayName, password, newpass, username))
                {
                    MessageBox.Show("Cập Nhật Thành Công!!!");
                    if (updateAccount != null)
                        updateAccount(this, new AccountEven(AccountDAO.Instance.GetAccountByUserName(username)));
                    else
                    {
                        MessageBox.Show("Cập Nhật Không Thành Công!!!");
                    }

                }
            }
        }

        private event EventHandler<AccountEven> updateAccount;
        public event EventHandler<AccountEven> UpdateAccount
        {
            add { updateAccount += value; }
            remove { updateAccount -= value; }
        }
        #endregion
        #region event
        private void checkBox1_CheckedChanged(object sender, EventArgs e)
        {
            txtmatkhaumoi.UseSystemPasswordChar = false;
            txtnhaplai.UseSystemPasswordChar = false;
            if (cbxhienthi.Checked == false)
            {
                txtmatkhaumoi.UseSystemPasswordChar = true;
                txtnhaplai.UseSystemPasswordChar = true;
            }
        }

        private void fAccountProfile_Load(object sender, EventArgs e)
        {   
            txtmatkhau.UseSystemPasswordChar = true; 
        }
        public class AccountEven : EventArgs
        {
            private Account acc;

            public Account Acc
            {
                get
                {
                    return acc;
                }

                set
                {
                    acc = value;
                }
            }
            public AccountEven(Account acc)
            {
                this.Acc = acc;
            }
        }

        private void bntUpdate_Click(object sender, EventArgs e)
        {
            UpdateAccountInfo();
            txtmatkhau.Clear();
            txtmatkhaumoi.Clear();
            txtnhaplai.Clear();
            cbxhienthi.Checked = false;
        }

        private void btnExit_Click(object sender, EventArgs e)
        {
            this.Close();
        }
        #endregion

    }
}
