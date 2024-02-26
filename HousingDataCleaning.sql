/* Cleaning Data in SQL Queries */

Select *
From [SQL Housing].dbo.[Nashvile Housing]


-- Populate property address data
Select *
From [SQL Housing].dbo.[Nashvile Housing]
Where PropertyAddress is null


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [SQL Housing].dbo.[Nashvile Housing] a
JOIN [SQL Housing].dbo.[Nashvile Housing] b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null

UPDATE a 
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [SQL Housing].dbo.[Nashvile Housing] a
JOIN [SQL Housing].dbo.[Nashvile Housing] b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null


-- Seperate Address into separate columns

Select PropertyAddress
From [SQL Housing].dbo.[Nashvile Housing]

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)- 1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress)) as Address
From [SQL Housing].dbo.[Nashvile Housing]

ALTER TABLE [SQL Housing].dbo.[Nashvile Housing]
Add PropertySplitAddress Nvarchar(255);

Update [SQL Housing].dbo.[Nashvile Housing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)- 1)

ALTER TABLE [SQL Housing].dbo.[Nashvile Housing]
Add PropertySplitCity Nvarchar(255);

Update [SQL Housing].dbo.[Nashvile Housing]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress))



Select OwnerAddress
From [SQL Housing].dbo.[Nashvile Housing]


Select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)

From [SQL Housing].dbo.[Nashvile Housing]

ALTER TABLE [SQL Housing].dbo.[Nashvile Housing]
Add OwnerSplitAddress Nvarchar(255);

Update [SQL Housing].dbo.[Nashvile Housing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE [SQL Housing].dbo.[Nashvile Housing]
Add OwnerSplitCity Nvarchar(255);

Update [SQL Housing].dbo.[Nashvile Housing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)


ALTER TABLE [SQL Housing].dbo.[Nashvile Housing]
Add OwnerSplitState Nvarchar(255);

Update [SQL Housing].dbo.[Nashvile Housing]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


-- Sold as Vacant column

Select *
From [SQL Housing].dbo.[Nashvile Housing]


Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From [SQL Housing].dbo.[Nashvile Housing]
Group by SoldAsVacant
order by 2


Select SoldAsVacant
,	CASE When SoldAsVacant = 0 THEN 'No'
		 When SoldAsVacant = 1 THEN 'Yes'
		 END
From [SQL Housing].dbo.[Nashvile Housing]


Update [SQL Housing].dbo.[Nashvile Housing]
SET SoldAsVacant = 	
	CASE When SoldAsVacant = 0 THEN 'No'
		 When SoldAsVacant = 1 THEN 'Yes'
		 END

Alter Table [SQL Housing].dbo.[Nashvile Housing]
Alter Column SoldAsVacant varchar(3)


-- Remove Duplicates

WITH RowNumCTE AS(
Select *, 
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID) row_num
From [SQL Housing].dbo.[Nashvile Housing]
)
DELETE
From RowNumCTE
Where row_num > 1


-- Delete Unused Columns

Alter Table [SQL Housing].dbo.[Nashvile Housing]
Drop Column OwnerAddress, TaxDistrict,PropertyAddress