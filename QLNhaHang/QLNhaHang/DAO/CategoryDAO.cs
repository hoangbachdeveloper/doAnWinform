using QLNhaHang.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QLNhaHang.DAO
{
    public class CategoryDAO
    {
        private static CategoryDAO instance;

        public static CategoryDAO Instance
        {
            get
            {
                if (instance == null)
                    instance = new CategoryDAO();
                    return CategoryDAO.instance;
            }

           private set
            {
                CategoryDAO.instance = value;
            }
        }
        private CategoryDAO() { }

        public List<Category> GetListCategory()
        {
            string query = "SELECT * FROM dbo.FoodCategory";
            List<Category> list = new List<Category>();
            DataTable data = DataProvider.Instance.ExecuteQuery(query);
            foreach (DataRow item in data.Rows)
            {
                Category category = new Category(item);
                list.Add(category);
            }
            return list;
        }
        public bool GetNumeberOfFoodInCategory(int idCategory)
        {
            string query = "SELECT COUNT (*) FROM dbo.Food WHERE idCategory = " + idCategory;
            int result = DataProvider.Instance.ExecuteNonQuery(query);
            return result > 0;
        }
        public int DeleteCategory(int idCategory)
        {
           // FoodDAO.Instance.DeleteFoodByCateGoryId(idCategory);
            string query = string.Format("DELETE FROM FoodCategory WHERE id = {0}", idCategory);
            int result = DataProvider.Instance.ExecuteNonQuery(query);
            return result ;
        }
        public bool InsertCategory(string DisplayName)
        {
            string query = string.Format("INSERT INTO dbo.FoodCategory (name) VALUES (N'{0}')",  DisplayName);
            int result = DataProvider.Instance.ExecuteNonQuery(query);
            return result > 0;
        }
        public bool UpdateCategory(int idCategory, string DisplayName)
        {
            string query = string.Format("UPDATE dbo.FoodCategory SET name = N'{0}' WHERE id = N'{1}' ", DisplayName, idCategory);
            int result = DataProvider.Instance.ExecuteNonQuery(query);
            return result > 0;
        }
    }
}
