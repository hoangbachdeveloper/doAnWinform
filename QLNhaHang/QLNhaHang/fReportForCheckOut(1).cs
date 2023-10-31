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
    public partial class fReportForCheckOut : Form
    {
        public fReportForCheckOut()
        {
            InitializeComponent();
        }
        public string temp;
        public float totalPrice;
        private void fReportForCheckOut_Load(object sender, EventArgs e)
        {
            // TODO: This line of code loads data into the 'DoAnCuaBachDataSet2.USP_ExportBillToReport' table. You can move, or remove it, as needed.
            txtTotalPrice.Text = totalPrice.ToString();
            this.USP_ExportBillToReportTableAdapter.Fill(this.DoAnCuaBachDataSet2.USP_ExportBillToReport,temp );
            this.reportViewer1.RefreshReport();
        }
    }
}
