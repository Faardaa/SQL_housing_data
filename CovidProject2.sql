-- 1.The data that we are going to use it
SELECT *
FROM PortfolioProject..NashvilleHousing


-- 2.Standardize Sale Date Format
ALTER TABLE PortfolioProject..NashvilleHousing
ADD SaleDateConverted DATE

UPDATE PortfolioProject..NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate)

SELECT SaleDateConverted
FROM PortfolioProject..NashvilleHousing


-- 3.Populate Property Adress Data
-- There is some rows with same ParcelID but has null PropertyAddress.
UPDATE nvh1
SET nvh1.PropertyAddress = NULLIF(nvh2.PropertyAddress, nvh1.PropertyAddress) 
FROM PortfolioProject..NashvilleHousing nvh1
JOIN PortfolioProject..NashvilleHousing nvh2
	ON nvh1.ParcelID = nvh2.ParcelID
	AND nvh1.[UniqueID ] <> nvh2.[UniqueID ]
WHERE nvh1.PropertyAddress IS NULL

-- There is no rows with same ParcelID but null PropertyAddress any more
SELECT nvh1.[UniqueID ], nvh1.ParcelID, nvh1.PropertyAddress, nvh2.[UniqueID ], nvh2.ParcelID, nvh2.PropertyAddress
FROM PortfolioProject..NashvilleHousing nvh1
JOIN PortfolioProject..NashvilleHousing nvh2
	ON nvh1.ParcelID = nvh2.ParcelID
	AND nvh1.[UniqueID ] <> nvh2.[UniqueID ]
WHERE nvh1.PropertyAddress IS NULL


-- 4.Breaking out Property Address to the indivitual Columns (Address, City)
ALTER TABLE PortfolioProject..NashvilleHousing
ADD SplitedPropertyAddress nvarchar(255)
UPDATE PortfolioProject..NashvilleHousing
SET SplitedPropertyAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE PortfolioProject..NashvilleHousing
ADD SplitedPropertyCity nvarchar(255)
UPDATE PortfolioProject..NashvilleHousing
SET SplitedPropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

-- 5.Breaking out Owner Address to the indivitual Columns (Address, City, State) by using PARSENAME
SELECT OwnerAddress
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) Address
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) City
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) State
FROM PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
ADD SplitedOwnerAddress nvarchar(255)
UPDATE PortfolioProject..NashvilleHousing
SET SplitedOwnerAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE PortfolioProject..NashvilleHousing
ADD SplitedOwnerCity nvarchar(255)
UPDATE PortfolioProject..NashvilleHousing
SET SplitedOwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) 

ALTER TABLE PortfolioProject..NashvilleHousing
ADD SplitedOwnerState nvarchar(255)
UPDATE PortfolioProject..NashvilleHousing
SET SplitedOwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) 


-- 6.Organice SoldAsVacand column
SELECT SoldAsVacant, COUNT(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2 -- There are 'Y', 'N', 'Yes', 'No'

UPDATE PortfolioProject..NashvilleHousing
SET SoldAsVacant = (
CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END )


-- 7. Delete rows with the same values (Not best practice just for learning purpose)
-- Find rows with same values by uning join
SELECT *
FROM PortfolioProject..NashvilleHousing nvh1
JOIN PortfolioProject..NashvilleHousing nvh2
	ON nvh1.ParcelID = nvh2.ParcelID
	AND nvh1.PropertyAddress = nvh2.PropertyAddress
	AND nvh1.SalePrice = nvh2.SalePrice
	AND nvh1.SaleDate = nvh2.SaleDate
	AND nvh1.LegalReference = nvh2.LegalReference
	AND nvh1.[UniqueID ] <> nvh2.[UniqueID ]

-- Create CTE to define rows with the same value
WITH rowNumCTE AS(
	SELECT *,
		ROW_NUMBER() OVER(
		PARTITION BY ParcelID,
					 PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 ORDER BY UniqueID
		) row_num
	FROM PortfolioProject..	NashvilleHousing)
DELETE
FROM rowNumCTE
WHERE row_num > 1