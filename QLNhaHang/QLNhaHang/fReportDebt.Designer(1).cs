namespace QLNhaHang
{
    partial class fReportDebt
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            Microsoft.Reporting.WinForms.ReportDataSource reportDataSource1 = new Microsoft.Reporting.WinForms.ReportDataSource();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(fReportDebt));
            this.USP_ExportBillToReportBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.DoAnCuaBachDataSet = new QLNhaHang.DoAnCuaBachDataSet();
            this.groupPanel1 = new DevComponents.DotNetBar.Controls.GroupPanel();
            this.labelX1 = new DevComponents.DotNetBar.LabelX();
            this.txttotalPrice = new DevComponents.DotNetBar.Controls.TextBoxX();
            this.reportViewer1 = new Microsoft.Reporting.WinForms.ReportViewer();
            this.USP_ExportBillToReportTableAdapter = new QLNhaHang.DoAnCuaBachDataSetTableAdapters.USP_ExportBillToReportTableAdapter();
            this.DoAnCuaBachDataSet1 = new QLNhaHang.DoAnCuaBachDataSet1();
            ((System.ComponentModel.ISupportInitialize)(this.USP_ExportBillToReportBindingSource)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.DoAnCuaBachDataSet)).BeginInit();
            this.groupPanel1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.DoAnCuaBachDataSet1)).BeginInit();
            this.SuspendLayout();
            // 
            // USP_ExportBillToReportBindingSource
            // 
            this.USP_ExportBillToReportBindingSource.DataMember = "USP_ExportBillToReport";
            this.USP_ExportBillToReportBindingSource.DataSource = this.DoAnCuaBachDataSet;
            // 
            // DoAnCuaBachDataSet
            // 
            this.DoAnCuaBachDataSet.DataSetName = "DoAnCuaBachDataSet";
            this.DoAnCuaBachDataSet.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema;
            // 
            // groupPanel1
            // 
            this.groupPanel1.CanvasColor = System.Drawing.SystemColors.Control;
            this.groupPanel1.ColorSchemeStyle = DevComponents.DotNetBar.eDotNetBarStyle.Office2007;
            this.groupPanel1.Controls.Add(this.labelX1);
            this.groupPanel1.Controls.Add(this.txttotalPrice);
            this.groupPanel1.Controls.Add(this.reportViewer1);
            this.groupPanel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.groupPanel1.Font = new System.Drawing.Font("Times New Roman", 11.25F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic))), System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.groupPanel1.Location = new System.Drawing.Point(0, 0);
            this.groupPanel1.Name = "groupPanel1";
            this.groupPanel1.Size = new System.Drawing.Size(739, 366);
            // 
            // 
            // 
            this.groupPanel1.Style.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground2;
            this.groupPanel1.Style.BackColorGradientAngle = 90;
            this.groupPanel1.Style.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground;
            this.groupPanel1.Style.BorderBottom = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.groupPanel1.Style.BorderBottomWidth = 1;
            this.groupPanel1.Style.BorderColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBorder;
            this.groupPanel1.Style.BorderLeft = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.groupPanel1.Style.BorderLeftWidth = 1;
            this.groupPanel1.Style.BorderRight = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.groupPanel1.Style.BorderRightWidth = 1;
            this.groupPanel1.Style.BorderTop = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.groupPanel1.Style.BorderTopWidth = 1;
            this.groupPanel1.Style.CornerDiameter = 4;
            this.groupPanel1.Style.CornerType = DevComponents.DotNetBar.eCornerType.Rounded;
            this.groupPanel1.Style.TextAlignment = DevComponents.DotNetBar.eStyleTextAlignment.Center;
            this.groupPanel1.Style.TextColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelText;
            this.groupPanel1.Style.TextLineAlignment = DevComponents.DotNetBar.eStyleTextAlignment.Near;
            this.groupPanel1.TabIndex = 0;
            this.groupPanel1.Text = "In Hóa Đơn Ghi Nợ";
            // 
            // labelX1
            // 
            this.labelX1.Location = new System.Drawing.Point(487, 277);
            this.labelX1.Name = "labelX1";
            this.labelX1.Size = new System.Drawing.Size(131, 25);
            this.labelX1.TabIndex = 2;
            this.labelX1.Text = "Tổng Thanh Toán:";
            // 
            // txttotalPrice
            // 
            // 
            // 
            // 
            this.txttotalPrice.Border.Class = "TextBoxBorder";
            this.txttotalPrice.Location = new System.Drawing.Point(624, 277);
            this.txttotalPrice.Name = "txttotalPrice";
            this.txttotalPrice.Size = new System.Drawing.Size(100, 25);
            this.txttotalPrice.TabIndex = 1;
            // 
            // reportViewer1
            // 
            this.reportViewer1.Dock = System.Windows.Forms.DockStyle.Fill;
            reportDataSource1.Name = "DataSet1";
            reportDataSource1.Value = this.USP_ExportBillToReportBindingSource;
            this.reportViewer1.LocalReport.DataSources.Add(reportDataSource1);
            this.reportViewer1.LocalReport.ReportEmbeddedResource = "QLNhaHang.Report2.rdlc";
            this.reportViewer1.Location = new System.Drawing.Point(0, 0);
            this.reportViewer1.Name = "reportViewer1";
            this.reportViewer1.Size = new System.Drawing.Size(733, 341);
            this.reportViewer1.TabIndex = 0;
            // 
            // USP_ExportBillToReportTableAdapter
            // 
            this.USP_ExportBillToReportTableAdapter.ClearBeforeFill = true;
            // 
            // DoAnCuaBachDataSet1
            // 
            this.DoAnCuaBachDataSet1.DataSetName = "DoAnCuaBachDataSet1";
            this.DoAnCuaBachDataSet1.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema;
            // 
            // fReportDebt
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(739, 366);
            this.Controls.Add(this.groupPanel1);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "fReportDebt";
            this.Text = "Ghi Nợ";
            this.Load += new System.EventHandler(this.fReport_Load);
            ((System.ComponentModel.ISupportInitialize)(this.USP_ExportBillToReportBindingSource)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.DoAnCuaBachDataSet)).EndInit();
            this.groupPanel1.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.DoAnCuaBachDataSet1)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private DevComponents.DotNetBar.Controls.GroupPanel groupPanel1;
        private Microsoft.Reporting.WinForms.ReportViewer reportViewer1;
        private System.Windows.Forms.BindingSource USP_ExportBillToReportBindingSource;
        private DoAnCuaBachDataSet DoAnCuaBachDataSet;
        private DoAnCuaBachDataSetTableAdapters.USP_ExportBillToReportTableAdapter USP_ExportBillToReportTableAdapter;
        private DoAnCuaBachDataSet1 DoAnCuaBachDataSet1;
        private DevComponents.DotNetBar.LabelX labelX1;
        private DevComponents.DotNetBar.Controls.TextBoxX txttotalPrice;
    }
}