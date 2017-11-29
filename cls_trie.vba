Option Explicit

Public Keys As Collection
Public Children As Variant
Public IsLeaf As Boolean

Public tObject As Variant
Public tValue As Variant

Public Sub Init()
    Set Keys = New Collection
    ReDim Children(0 To 255) As cls_trie
    IsLeaf = False
    
    Set tObject = Nothing
    tValue = 0
End Sub

Public Function GetNodeAt(index As Integer) As cls_trie
    Set GetNodeAt = Children(index)
End Function

Public Sub CreateNodeAt(index As Integer)
    Set Children(index) = New cls_trie
    Children(index).Init
End Sub

'''
'Following function will retrieve node for a given key,
'creating a entire new branch if necessary
'''
Public Function GetNode(ByRef key As Variant) As cls_trie
    Dim node As cls_trie
    Dim b() As Byte
    Dim i As Integer
    Dim pos As Integer
    
    b = CStr(key)
    Set node = Me
    
    For i = 0 To UBound(b) Step 2
        pos = b(i) Mod 256
        
        If (node.GetNodeAt(pos) Is Nothing) Then
            node.CreateNodeAt pos
        End If
        
        Set node = node.GetNodeAt(pos)
    Next
    
    If (node.IsLeaf) Then
        'already existed
    Else
        node.IsLeaf = True
        Keys.Add key
    End If
    
    Set GetNode = node
End Function

'''
'Following function will get the value for a given key
'Creating the key if necessary
'''
Public Function GetValue(ByRef key As Variant) As Variant
    Dim node As cls_trie
    Set node = GetNode(key)
    GetValue = node.tValue
End Function

'''
'Following sub will set a value to a given key
'Creating the key if necessary
'''
Public Sub SetValue(ByRef key As Variant, value As Variant)
    Dim node As cls_trie
    Set node = GetNode(key)
    node.tValue = value
End Sub

'''
'Following sub will sum up a value for a given key
'Creating the key if necessary
'''
Public Sub SumValue(ByRef key As Variant, value As Variant)
    Dim node As cls_trie
    Set node = GetNode(key)
    node.tValue = node.tValue + value
End Sub

'''
'Following function will validate if given key exists
'''
Public Function Exists(ByRef key As Variant) As Boolean
    Dim node As cls_trie
    Dim b() As Byte
    Dim i As Integer
    
    b = CStr(key)
    Set node = Me
    
    For i = 0 To UBound(b) Step 2
        Set node = node.GetNodeAt(b(i) Mod 256)
        
        If (node Is Nothing) Then
            Exists = False
            Exit Function
        End If
    Next
    
    Exists = node.IsLeaf
End Function

'''
'Following function will get another Trie from given key
'Creating both key and trie if necessary
'''
Public Function GetTrie(ByRef key As Variant) As cls_trie
    Dim node As cls_trie
    Set node = GetNode(key)
    
    If (node.tObject Is Nothing) Then
        Set node.tObject = New cls_trie
        node.tObject.Init
    End If
    
    Set GetTrie = node.tObject
End Function

