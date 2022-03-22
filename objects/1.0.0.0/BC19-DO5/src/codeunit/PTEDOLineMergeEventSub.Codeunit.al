codeunit 62050 "PTE DO Line Merge Event Sub"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CDO Events", 'OnBeforeInsertSignature', '', true, true)]
    local procedure CDO_OnBeforeInsertSignature(FirstToContactNo: Code[20]; FormatAsHtml: Boolean; MailBody: Text; var CIDAttachment: Record "CDO E-Mail Template Attachment"; var EMailTemplateLine: Record "CDO E-Mail Template Line"; var FilterRecord: RecordRef)
    var
        MailBodyTextBuilder: TextBuilder;
        RegEx: Codeunit Regex;
        RegExMatches: Record Matches;
        RegxGroups: Record Groups;
        SearchPattern: Text;
        SplitResult: List of [Text];
    begin

        MailBodyTextBuilder.Append(MailBody);
        MailBodyTextBuilder.Replace('%TEST', '<b>Das ist ein bisschen besser als der andere quatch</b>');
        MailBody := MailBodyTextBuilder.ToText();

        SearchPattern := '^[\s\S]*<tbody*[\s\S]*id="cdoline"[^\>]*>([\s\S]*)<\/tbody>[\s\S]*$';
        RegEx.Match(MailBody, SearchPattern, 0, RegExMatches);
        if RegExMatches.FindFirst() then
            repeat
                Message('Index: %1\%2', RegExMatches.Index, RegExMatches.ReadValue());
            until RegExMatches.Next() = 0;


        RegEx.Split(MailBody, SearchPattern, 5, SplitResult);
        message('Splits %1', SplitResult.Count);

        RegEx.Groups(RegExMatches, RegxGroups);
        Message(RegxGroups.ReadValue());

    end;
}
