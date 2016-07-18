# OldNavy_DER_analysis
Parses Old Navy DER and creates reports


# How to Use

If you have access to the Old Navy DER, which means, if you're 
a manager at an Old Navy, then all you have to do is download the 
Excel spreadsheet.

Everything is contained in the macro aside from the "Key" sheet in the
spreadsheet, I hope to be abosrbing that into the macro soon.

## Step 1. Download Spreadsheet

## Step 2. Create a New Sheet (Call it Whatever You Desire)

## Step 3. Access the DER and Copy and Paste
Just hit ctrl+A in the DER view, then select cell A1 in the new sheet
and paste everything. It'll look terrible, but that's okay.

## Step 4. Run the CleanTheDER Macro
This can be done by looking through the macros or by pressing
### ctrl+shift+K


# Wrap Up

The macro will organize the data into a table and create a new table
with the break down of units and hours per division

It will also create a sheet for each division. Within each division's sheet 
will be two pivot tables. One of them will show all new items and the other
will only show replenishment items if the quantity is more than 30.

You can adjust these parameters in the filters menu, if you want.

Lastly, there is no need to delete sheets. When It's time for another shipment,
the just copy and paste the DER into a sheet and run the macro again. It will 
automatically delete and recreate the sheets for each division.