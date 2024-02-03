# SQL_housing_data
Overview:
This project aims to clean and standardize the 'NashvilleHousing' dataset from the 'PortfolioProject' database. The dataset contains information about property sales, including date, address, owner details, and sale prices.

Steps Taken:
1.Standardize Sale Date Format:
Added 'SaleDateConverted' column to store standardized date format.

2.Populate Property Address Data:
Updated rows with null 'PropertyAddress' using information from other rows with the same 'ParcelID'.

3.Break Down Property Address:
Split 'PropertyAddress' into separate 'SplitedPropertyAddress' and 'SplitedPropertyCity' columns.

4.Break Down Owner Address:
Used PARSENAME to split 'OwnerAddress' into 'SplitedOwnerAddress', 'SplitedOwnerCity', and 'SplitedOwnerState' columns.

5.Organize 'SoldAsVacant' Column:
Standardized values in the 'SoldAsVacant' column to 'Yes' or 'No'.

6.Delete Duplicate Rows:
Removed rows with identical values to ensure data integrity.

Usage
To use this project, follow these steps:
1.Execute the SQL script provided in 'DataCleaningScript.sql' on your SQL Server.
2.Review the 'NashvilleHousing' table for the cleaned data.
3.Feel free to adapt the script or contribute to further improvements.

Contributors
Ahmadli Farda
