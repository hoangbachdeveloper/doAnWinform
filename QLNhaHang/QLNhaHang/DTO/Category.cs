﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QLNhaHang.DTO
{
    public class Category
    {
        private int iD;
        private string name;
        public Category(int id, string name)
        {
            this.ID = id;
            this.Name = name;
        }
        public Category(DataRow row)
        {
            this.ID =(int)row["id"];
            this.Name = row["name"].ToString(); ;
        }

        public int ID
        {
            get
            {
                return iD;
            }

            set
            {
                iD = value;
            }
        }

        public string Name
        {
            get
            {
                return name;
            }

            set
            {
                name = value;
            }
        }
    }
}
