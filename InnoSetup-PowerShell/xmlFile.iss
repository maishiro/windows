[Code]

function XMLOpenFile(const FileName: String; var XMLDoc: Variant): Boolean;
begin
  Result := False;
  XMLDoc := CreateOleObject('Msxml2.DOMDocument.6.0');
  XMLDoc.async := False;
  Log( 'OpenXMLFile  FileName: ' + FileName );
  XMLDoc.load(FileName);
  if XMLDoc.parseError.errorCode <> 0 then
  begin
    Log( 'OpenXMLFile  LoadXML error: ' + XMLDoc.parseError.reason );
  end
  else
    Result := True;
end;

function XMLReadValue(const XMLDoc: Variant; const XPath: String; var Value: String): Boolean;
begin
  Result := False;
  Value := '';
  if not VarIsEmpty(XMLDoc) then
  begin
    XMLDoc.setProperty('SelectionLanguage', 'XPath');
    Value := XMLDoc.selectSingleNode(XPath).text;
    Result := True;
  end
  else
  begin
    Log( 'LoadValueFromXML  The XML document is not open.' );
  end;
end;

function XMLUpdateValue(var XMLDoc: Variant; const XPath, NewValue: String): Boolean;
begin
  Result := False;
  if not VarIsEmpty(XMLDoc) then
  begin
    XMLDoc.setProperty('SelectionLanguage', 'XPath');
    if not VarIsEmpty(XMLDoc.selectSingleNode(XPath)) then
    begin
      XMLDoc.selectSingleNode(XPath).text := NewValue;
      Result := True;
    end
    else
    begin
      Log( 'UpdateXMLValue  selectSingleNode failed' );
    end;
  end
  else
  begin
    Log( 'UpdateXMLValue  The XML document is not open.' );
  end;
end;

function XMLSaveFile(const XMLDoc: Variant; const FileName: String): Boolean;
begin
  Result := False;
  if not VarIsEmpty(XMLDoc) then
  begin
    XMLDoc.save(FileName);
    Result := True;
  end
  else
  begin
    Log( 'UpdateXMLValue  The XML document is not open.' );
  end;
end;