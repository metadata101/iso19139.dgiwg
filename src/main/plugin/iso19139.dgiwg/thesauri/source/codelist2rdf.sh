DICT=${1? Missing NGMP dictionary name (es: NGMP_ThematicCode)}

echo Extracting $DICT



cat ngmpCodelists.xml | xmlstarlet sel \
	-N skos="http://www.w3.org/2004/02/skos/core#" \
	-N rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" \
	-N dc="http://purl.org/dc/elements/1.1/" \
	-N dcterms="http://purl.org/dc/terms/" \
	-t \
	-e rdf:RDF -n \
	-m "//gmx:CodeListDictionary[@gml:id=\"$DICT\"]" \
	-o "   " -e 'skos:ConceptScheme' -a rdf:about -v gmx:codeEntry[1]/gmx:CodeDefinition/gml:identifier/@codeSpace -b -n \
	-o "      " -e dc:title -v gml:name -b -n \
	-o "      " -e dc:description -v gml:description -b -n \
	-o "   " -b -n -n \
	-m gmx:codeEntry \
	-o "   " -e 'skos:Concept' -a rdf:about -v gmx:CodeDefinition/@gml:id -b -n \
	-o "      " -e skos:altLabel -v gmx:CodeDefinition/gml:identifier -b -n \
	-o "      " -e skos:prefLabel -a xml:lang -o "en" -b -v gmx:CodeDefinition/gml:name -b -n \
	-o "      " -e skos:scopeNote -a xml:lang -o "en" -b -v gmx:CodeDefinition/gml:description -b -n \
	-o "      " -e skos:inScheme -a rdf:resource -v gmx:CodeDefinition/gml:identifier/@codeSpace -b -b -n \
	-o "   " -b -n \
	-b -n > ${DICT}.rdf
	
	
