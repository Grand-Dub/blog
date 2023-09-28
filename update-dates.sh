#/bin/bash
#-----------------------------------------------------------------------------------------------------------------------------------------
# But: Mettre à jour automatiquement la date du Front Matter des pages des répértoires référencés dans DIRS
# Si l'entrée "date:" n'existe pas, il faut la créer. Je suppose que le Front Matter existe 
# À VÉRIFIER (la création de la "date:")
#-----------------------------------------------------------------------------------------------------------------------------------------


#DIRS=("_posts" "_pages")
DIRS=("_posts")

nb=0
modif=false
for d in ${DIRS[@]} ; do
    for f in $(find $d -type f) ; do
        dateModification=$(stat "$f" -c %y | sed -E 's/^([0-9]{4}-[0-9]{2}-[0-9]{2}).*$/\1/')

        dateInFile=$(sed -E '/^---[ \t]*$/,/^---[ \t]*$/!d' "$f"|sed -n '/^date:/p' |sed -E 's/^date: (.+)$/\1/')
        if [ "$dateInFile" != "$dateModification" ] ; then
            echo "\"$f\" : \"date: $dateInFile\" -> \"date: $dateModification\""
            modif=true
            nb=$((nb+1))
            #Modification du fichier
            sed -i "s/^date: $dateInFile/date: $dateModification/" "$f"
        fi
    done
done
if [ "$modif" = "true" ] ; then
    echo "---------------------------------------------------------------------------------"
    echo "$nb fichier(s) modifié(s)"
    echo "---------------------------------------------------------------------------------"
fi
