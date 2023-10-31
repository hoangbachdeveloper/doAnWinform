using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QLNhaHang.DTO
{
    public class Customer
    {
        private string userName;
        private string passWord;
        private string guesName;
        private string address;
        private string number;
        public Customer (string userName, string passWord, string guesName, string address, string number)
        {
            this.UserName = userName;
            this.PassWord = passWord;
            this.GuesName = guesName;
            this.Address = address;
            this.Number = number;
        }
        public Customer(DataRow row)
        {
            this.UserName = row["userName"].ToString();
            this.PassWord = row["passWord"].ToString();
            this.GuesName = row["guesName"].ToString();
            this.Address = row["address"].ToString();
            this.Number = row["number"].ToString();
        }

        public string UserName
        {
            get
            {
                return userName;
            }

            set
            {
                userName = value;
            }
        }

        public string PassWord
        {
            get
            {
                return passWord;
            }

            set
            {
                passWord = value;
            }
        }

        public string GuesName
        {
            get
            {
                return guesName;
            }

            set
            {
                guesName = value;
            }
        }

        public string Address
        {
            get
            {
                return address;
            }

            set
            {
                address = value;
            }
        }

        public string Number
        {
            get
            {
                return number;
            }

            set
            {
                number = value;
            }
        }
    }
}
