VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ThisWorkbook"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True

Sub EdgeCleaner(NumOfRows As Integer)
    On Error GoTo Errorcatch:
     
    Dim CurrentSheet As Worksheet
    Dim StringRange As String
        
    Set CurrentSheet = Application.ActiveSheet
    
    CurrentSheet.Rows("1:11").Delete
    CurrentSheet.Columns(1).Delete
    CurrentSheet.Columns(6).Delete
    StringRange = CStr(NumOfRows + 1) + ":" + CStr(NumOfRows + 7)
    CurrentSheet.Rows(StringRange).Delete
    
    CurrentSheet.Rows(NumOfRows).Delete
    CurrentSheet.Cells(NumOfRows, 1).Value = "Bottom"
    
Exit Sub

Errorcatch:
MsgBox Err.Description
       
End Sub
Function getTotalRows() As Integer
    Dim CurrentSheet As Worksheet
    Dim Index As Integer
    
    Set CurrentSheet = Application.ActiveSheet
    CurrentCellValue = CurrentSheet.Cells(12, 3).Value
    Index = 1
    While CurrentCellValue <> "Store Total"
        Index = Index + 1
        CurrentCellValue = CurrentSheet.Cells(Index + 12, 3).Value
    Wend
    getTotalRows = Index
    ' MsgBox (getTotalRows)
    
End Function
Sub GetImageAltText()
 
    ' This loops through all of the images and gets the
    '  alternative text for the image and places it in a
    '  worksheet called "List". This is done so we can check
    '  to make sure we can automate the conversion.
    
    Dim CurrentImage As Shape
    Dim CurrentSheet As Worksheet
    Dim OutputSheet As Worksheet
    
    Dim CurrentImageAltText As String
    Dim Image_Column As Integer
    Dim Image_Row As Integer
    Dim OutputRow As Integer
    
    Set CurrentSheet = ActiveSheet
    Set OutputSheet = ActiveWorkbook.Sheets("Sheet5")
    OutputRow = 1
    
    For Each CurrentImage In CurrentSheet.Shapes
        CurrentImageAltText = CurrentImage.AlternativeText
 
        Image_Column = CurrentImage.TopLeftCell.Column
        Image_Row = CurrentImage.TopLeftCell.Row
 
        OutputSheet.Cells(OutputRow, 1).Value = Image_Column
        OutputSheet.Cells(OutputRow, 2).Value = Image_Row
        OutputSheet.Cells(OutputRow, 3).Value = CurrentImageAltText
 
        OutputRow = OutputRow + 1
    Next CurrentImage
    
End Sub

Sub ReplaceLockedImagesWithCellText()
 
    Dim CurrentImage As Shape
    Dim CurrentSheet As Worksheet
    Dim CurrentImageAltText As String
    Dim Image_Row As Integer
    Dim Image_Column As Integer
    Dim Index As Integer
    Dim TestValue As String
    
    Set CurrentSheet = Application.ActiveSheet
 
    For Each CurrentImage In CurrentSheet.Shapes
        
        ' Get the location and alternative text information for the current image
        CurrentImageAltText = CurrentImage.AlternativeText
        Image_Column = CurrentImage.TopLeftCell.Column
        Image_Row = CurrentImage.TopLeftCell.Row
        
        If CurrentImageAltText = "http://pposwa01.gap.com:9082/storenet/images/en/on/button_asterisk.gif" Then
            CurrentSheet.Cells(Image_Row, Image_Column).Value = "New"
        End If
    Next CurrentImage
    
    Index = 1
    TestValue = CurrentSheet.Cells(1, 1).Value
    While TestValue <> "Bottom"
        If CurrentSheet.Cells(Index, 1).Value <> "New" Then
            CurrentSheet.Cells(Index, 1).Value = "R"
        End If
        
        Index = Index + 1
        TestValue = CurrentSheet.Cells(Index, 1).Value
    Wend
    CurrentSheet.Cells(1, 1).Value = "New/Replen"
End Sub
Sub DeleteImages()
 
    Dim CurrentImage As Shape
    Dim CurrentSheet As Worksheet
  
    Set CurrentSheet = Application.ActiveSheet
 
    For Each CurrentImage In CurrentSheet.Shapes
        CurrentImage.Delete
    Next CurrentImage
    
End Sub
Sub AddNewColumns()
    On Error GoTo Errorcatch:
    Dim KeySheet As Worksheet
    Dim CurrentSheet As Worksheet
    Dim StringRange As String
    Dim Index As Integer
    Dim littleCounter As Integer
    Dim TestValue As String

    Set CurrentSheet = Application.ActiveSheet
    Set KeySheet = Sheets("Key")

    CurrentSheet.Range("b1:c1").EntireColumn.Insert
    CurrentSheet.Range("E1:F1").EntireColumn.Insert
    CurrentSheet.Cells(1, 2).Value = "Division"
    CurrentSheet.Cells(1, 3).Value = "Department"
    CurrentSheet.Cells(1, 5).Value = "Description"
    CurrentSheet.Cells(1, 6).Value = "Color"
    
    Index = 2
    TestValue = CurrentSheet.Cells(1, 1).Value
    While TestValue <> "Bottom"
        temp = CurrentSheet.Cells(Index, 7).Value
        
        ' Populates the Division Column
        If IsError(Application.Match(temp, KeySheet.Range("B2:B10"), 0)) Then
            CurrentSheet.Cells(Index, 2).Value = CurrentSheet.Cells(Index - 1, 2)
        Else
            MatchCellDivision = Application.Match(temp, KeySheet.Range("B2:B10"), 0)
            CurrentSheet.Cells(Index, 2).Value = Application.WorksheetFunction.Index(KeySheet.Range("B2:B10"), MatchCellDivision, 1)
        End If
        
        ' Populates the Department Column
        If IsError(Application.Match(temp, KeySheet.Range("D2:D41"), 0)) Then
            CurrentSheet.Cells(Index, 3).Value = CurrentSheet.Cells(Index - 1, 3)
        Else
            MatchCellDepartment = Application.Match(temp, KeySheet.Range("D2:D41"), 0)
            CurrentSheet.Cells(Index, 3).Value = Application.WorksheetFunction.Index(KeySheet.Range("D2:D41"), MatchCellDepartment, 1)
        End If
        
        ' Populates the Program Column. That way every item had a SKU associated with it
        If CurrentSheet.Cells(Index, 4).Value = "" Then
            CurrentSheet.Cells(Index, 4).Value = CurrentSheet.Cells(Index - 1, 4).Value
        End If
        
        ' Populates Description Column
        For t = 0 To 9
            If InStr(1, Mid(temp, 4, 3), CStr(t)) > 0 Then
                CurrentSheet.Cells(Index, 6).Value = temp
                Exit For
            End If
            Next t
        If t = 10 Then
            CurrentSheet.Cells(Index, 5).Value = temp
        Else
            CurrentSheet.Cells(Index, 5).Value = CurrentSheet.Cells(Index - 1, 5).Value
        End If
        
                
        
        Index = Index + 1
        TestValue = CurrentSheet.Cells(Index, 1).Value
    Wend
    CurrentSheet.Columns(7).Delete
    CurrentSheet.Columns(8).Delete

    ' Removes unwanted rows. I kept this separate from above while because it was buggy in testing
    ' with all of it together.
    Index = 2
    TestValue = CurrentSheet.Cells(1, 1).Value
    While TestValue <> "Bottom"
        CurrentSheet.Rows(Index).RowHeight = 17
        If CurrentSheet.Cells(Index, 7) = 0 Then
            CurrentSheet.Rows(Index).Delete
        Else
            Index = Index + 1
        End If
        TestValue = CurrentSheet.Cells(Index, 1).Value
    Wend
    
    
    Index = 2
    littleCounter = 0
    TestValue = CurrentSheet.Cells(1, 1).Value
    While TestValue <> "Bottom"
        If Index = 2 Then
            CurrentSheet.Cells(2, 9).Value = CurrentSheet.Cells(Index, 2).Value
            CurrentSheet.Cells(2, 10).Value = CurrentSheet.Cells(Index, 7).Value
            CurrentSheet.Cells(1, 9).Value = "Division"
            CurrentSheet.Cells(1, 10).Value = "# of Units"
            CurrentSheet.Cells(1, 11).Value = "# of Hours"
            CurrentSheet.Cells(11, 9).Value = "Total"
        ElseIf CurrentSheet.Cells(Index, 2).Value = CurrentSheet.Cells(Index - 1, 2).Value Then
            littleTemp = CurrentSheet.Cells(2 + littleCounter, 10).Value
            CurrentSheet.Cells(2 + littleCounter, 10).Value = littleTemp + CurrentSheet.Cells(Index, 7).Value
        Else
            CurrentSheet.Cells(2 + littleCounter, 11).Value = CurrentSheet.Cells(2 + littleCounter, 10) / 175
            littleCounter = littleCounter + 1
            CurrentSheet.Cells(2 + littleCounter, 9).Value = CurrentSheet.Cells(Index, 2).Value
            CurrentSheet.Cells(2 + littleCounter, 10).Value = CurrentSheet.Cells(Index, 7).Value
        End If
        Index = Index + 1
        TestValue = CurrentSheet.Cells(Index, 1).Value
    Wend
    CurrentSheet.Cells(2 + littleCounter, 11).Value = CurrentSheet.Cells(2 + littleCounter, 10) / 175
    CurrentSheet.Cells(11, 10).Value = Application.WorksheetFunction.Sum(CurrentSheet.Range("J2:J10"))
    CurrentSheet.Cells(11, 11).Value = Application.WorksheetFunction.Sum(CurrentSheet.Range("K2:K10"))
    
    CurrentSheet.Columns("K:K").Select
    Selection.NumberFormat = "0.00"
    CurrentSheet.Range("I1:K1").Select
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorAccent2
        .TintAndShade = -0.249977111117893
        .PatternTintAndShade = 0
    End With
    CurrentSheet.Range("I2:I9").Select
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorDark2
        .TintAndShade = -9.99786370433668E-02
        .PatternTintAndShade = 0
    End With
    CurrentSheet.Range("J2:J9").Select
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorAccent1
        .TintAndShade = -0.249977111117893
        .PatternTintAndShade = 0
    End With
    CurrentSheet.Range("K2:K9").Select
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorAccent4
        .TintAndShade = 0.599993896298105
        .PatternTintAndShade = 0
    End With
    CurrentSheet.Range("I11:K11").Select
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorAccent6
        .TintAndShade = -0.249977111117893
        .PatternTintAndShade = 0
    End With
    
    CurrentSheet.Rows(Index).Delete
    CurrentSheet.Columns("A:K").AutoFit
    
    
Exit Sub

Errorcatch:
    MsgBox Err.Description
   
End Sub

Sub CreatePivotTables()
    Dim CurrentSheet As Worksheet
    Dim KeySheet As Worksheet
    Dim DivSheet As Worksheet
    Dim Index As Integer
    Dim Length As Integer
    Dim StringRange As String
    
    Set KeySheet = Application.Sheets("Key")
    Set CurrentSheet = Application.ActiveSheet
    
    Index = 1
    While CurrentSheet.Cells(Index, 1) <> ""
        Index = Index + 1
    Wend
    Length = Index - 1
    
    StringRange = "A1:G" + CStr(Length)
    CurrentSheet.ListObjects.Add(xlSrcRange, CurrentSheet.Range(StringRange), , xlYes).Name = "Table1"
    
    For Each DivSheet In ActiveWorkbook.Sheets
        If DivSheet.Name = "ACESS~SHOES~NONAPPRL" Then
            Application.DisplayAlerts = False
            Worksheets(DivSheet.Name).Delete
            Application.DisplayAlerts = True
        ElseIf IsError(Application.Match(DivSheet.Name, KeySheet.Range("B2:B10"), 0)) Then
            DivSheet.Name = DivSheet.Name
        Else
            Application.DisplayAlerts = False
            Worksheets(DivSheet.Name).Delete
            Application.DisplayAlerts = True
        End If
    Next DivSheet
   
'  Creates new sheets for each division's pivot table
    For Each CurrentCell In KeySheet.Range("B2:B9")
        temp = CurrentCell.Value
        If InStr(1, temp, "/") Then
            temp = Split(temp, "/")
            temp = Join(temp, "~")
        End If
        Sheets.Add(Before:=Application.Sheets("RAWDER")).Name = temp
            
        Set CurrentSheet = Application.Sheets(temp)
        ActiveWorkbook.PivotCaches.Create( _
            SourceType:=xlDatabase, _
            SourceData:="Table1", _
            Version:=6).CreatePivotTable _
            TableDestination:=CurrentSheet.Cells(4, 1), _
            TableName:="New " + temp, _
            DefaultVersion:=6

        With CurrentSheet.PivotTables("New " + temp)
            .PivotFields("New/Replen").Orientation = xlPageField
            .PivotFields("New/Replen").Position = 1
            .PivotFields("Division").Orientation = xlPageField
            .PivotFields("Division").Position = 1
            .PivotFields("Program").Orientation = xlRowField
            .PivotFields("Program").Position = 1
            .PivotFields("Description").Orientation = xlRowField
            .PivotFields("Description").Position = 2
            .PivotFields("Color").Orientation = xlRowField
            .PivotFields("Color").Position = 3
    
            .AddDataField .PivotFields("Units per Color"), "Sum of Units per Color", xlSum
            .PivotFields("New/Replen").ClearAllFilters
            .PivotFields("New/Replen").CurrentPage = "New"
            .PivotFields("Division").ClearAllFilters
            .PivotFields("Division").CurrentPage = CurrentCell.Value
            .PivotFields("Description").Subtotals = _
                Array(False, False, False, False, False, False, False, False, False, False, False, False)
            .TableStyle2 = "PivotStyleMedium6"
        End With
        
        ActiveWorkbook.PivotCaches.Create( _
            SourceType:=xlDatabase, _
            SourceData:="Table1", _
            Version:=6).CreatePivotTable _
            TableDestination:=CurrentSheet.Cells(1, 5), _
            TableName:="Replen " + temp, _
            DefaultVersion:=6

        With CurrentSheet.PivotTables("Replen " + temp)
            .PivotFields("New/Replen").Orientation = xlPageField
            .PivotFields("New/Replen").Position = 1
            .PivotFields("Division").Orientation = xlPageField
            .PivotFields("Division").Position = 1
            .PivotFields("Program").Orientation = xlRowField
            .PivotFields("Program").Position = 1
            .PivotFields("Description").Orientation = xlRowField
            .PivotFields("Description").Position = 2
            .PivotFields("Color").Orientation = xlRowField
            .PivotFields("Color").Position = 3
    
            .AddDataField .PivotFields("Units per Color"), "Sum of Units per Color", xlSum
            .PivotFields("New/Replen").ClearAllFilters
            .PivotFields("New/Replen").CurrentPage = "R"
            .PivotFields("Division").ClearAllFilters
            .PivotFields("Division").CurrentPage = CurrentCell.Value
            .PivotFields("Description").Subtotals = _
                Array(False, False, False, False, False, False, False, False, False, False, False, False)
            .PivotFields("Program").PivotFilters.Add2 Type:=xlValueIsGreaterThanOrEqualTo, _
            DataField:=.PivotFields("Sum of Units per Color"), Value1:=30
            .TableStyle2 = "PivotStyleMedium6"
        End With
    Next CurrentCell
  
End Sub


Sub CleanTheDER()
Attribute CleanTheDER.VB_ProcData.VB_Invoke_Func = "K\n14"
    On Error GoTo Errorcatch:
    Dim TotalRows As Integer
    
    TotalRows = getTotalRows()
    'TotalRows = 1507
    Call EdgeCleaner(TotalRows)
    ' Call GetImageAltText
    Call ReplaceLockedImagesWithCellText
    Call DeleteImages
    Call AddNewColumns
    Call CreatePivotTables
Exit Sub

Errorcatch:
MsgBox Err.Description
   
End Sub
