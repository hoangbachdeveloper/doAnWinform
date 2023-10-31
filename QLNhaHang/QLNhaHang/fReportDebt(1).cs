using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.IO;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QLNhaHang
{
    public partial class fReportDebt : Form
    {
        public fReportDebt()
        {
            InitializeComponent();
        }
        public string temp;
        public float totalPrice;
        private void fReport_Load(object sender, EventArgs e)
        {
            // TODO: This line of code loads data into the 'DoAnCuaBachDataSet.USP_ExportBillToReport' table. You can move, or remove it, as needed.
            txttotalPrice.Text = totalPrice.ToString();
            this.USP_ExportBillToReportTableAdapter.Fill(this.DoAnCuaBachDataSet.USP_ExportBillToReport, temp);

            this.reportViewer1.RefreshReport();
        }
    }
}
