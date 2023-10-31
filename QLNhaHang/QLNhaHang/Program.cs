using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QLNhaHang
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            //Application.Run(new fTableManager());
            //Application.Run(new fAdmin());
             Application.Run(new flogin());
            //Application.Run(new fStatistical());
            //Application.Run(new fDebt());
            //Application.Run(new fReport());
        }
    }
}
