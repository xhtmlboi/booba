let quotes =
  [| ( "Nougat"
     , "Mon prof m’a dit « tu finiras à Nanterre », je ne voulais pas \
        réussir de toute manière" )
   ; "La mort leur va si bien", "Beretta dans la bouche, tu vas me remettre"
   ; "Tony Sosa", "Encore quelques millions et je ne saurais plus qui tu es"
   ; ( "Banlieue Ouest"
     , "Chez nous y a pas l’OTAN, alors si y a la guerre ça va durer \
        longtemps" )
   ; ( "Groupe sanguin"
     , "La vie c’est dur, ça fait mal dès que ça commence. C’est pour ça \
        qu’on pleure tous à la naissance " )
   ; "Jour de paye", "J’ai fait la guerre pour habiter Rue de la paix"
   ; ( "Boulbi"
     , "Je traîne en bas de chez toi je fais chuter le prix de l’immobilier" )
   ; ( "Jour de paye"
     , "Tu veux t’assoir sur le trône, faudra t’asseoir sur mes genoux" )
   ; ( "Pitbull"
     , "Des fois j’me dope comme un coureur cycliste. Quand se réveillent \
        mes cicatrices, j’me sens si seul et si triste " )
   ; ( "Pas l’temps pour les regrets"
     , "Hors de portée, mort de rire sans remords quand j’écoute les menaces \
        de mort des forces de l’ordre " )
   ; ( "Game Over"
     , "Tout le monde peut s’en sortir, aucune cité n’a de barreaux" )
   ; ( "Boulbi"
     , "Les rappeurs m’envient, sont tous en galère. Un jour de mon salaire \
        c’est leur assurance vie " )
   ; ( "Rats des villes"
     , "C’est pas qu’j’aime pas me mélanger, mais disons/Simplement qu’les \
        aigles ne volent pas avec les pigeons ! " )
   ; ( "Pitbull"
     , "J’en suis où j’en suis, malgré tellement d’erreurs/J’suis trop en \
        avance pour leur demander l’heure" )
   ; ( "A.C Milan"
     , "Le savoir est une arme, j’suis calibré, j’lis pas d’bouquin" )
  |]
;;

let pick () =
  let () = Random.self_init () in
  let le = Array.length quotes in
  let ix = Random.int le in
  let source, text = Array.get quotes ix in
  Format.asprintf {|« @[<hov 1>%s@] »  - Booba in "%s"|} text source
;;
