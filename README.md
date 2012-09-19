ME – en dator
================================

*[Källa](http://fileadmin.cs.lth.se/cs/Education/EDA070/lectures/lagniva/mebeskrivning.pdf)*

Inledning
-------------------------
ME är en påhittad dator, men den har likheter med riktiga datorer: det finns ett maskinspråk med olika instruktioner, det finns minne och register, och så vidare. Vi kommer att skriva program i datorns assemblerspråk. Instruktionerna i assemblerspråket motsvarar direkt maskininstruktioner men skrivs med symboliska namn i stället för med nollor och ettor.
Till sist beskrivs en emulator1 för assemblerspråket i datorn.

ME-datorn
-------------------------
###Datorns uppbyggnad och assemblerspråk
ME-datorn har ett minne om 1000 minnesceller, numrerade 0–999. Datorn har alltså en ”adress rymd” om 1000 minnesceller — jämför detta med en persondator som har några miljarder minnesceller. I varje minnescell kan man lagra ett heltal, positivt eller negativt — jämför detta med en persondator där man förutom heltal också kan lagra flyttal (reella tal).
Förutom i minnet kan man lagra data i register. Det finns fem register: _R1_, _R2_, _R3_, _R4_ eller _R5_. Varje register kan innehålla ett positivt eller negativt heltal. Anledningen till att man har register är att det går snabbare att komma åt ett tal i ett register än att hämta det från minnet. När man gör beräkningar brukar man därför ha operanderna till beräkningen i register, även om detta inte är nödvändigt i ME-datorn.  
ME-datorn har instruktioner för aritmetik (de fyra räknesätten) och för villkorliga och ovill korliga hopp. En stoppinstruktion och instruktioner för inläsning och utskrift finns också.
Ett program i datorns assemblerspråk bestär av ett antal satser. En sats består av en instruktion och noll till tre parametrar. Parametrarna anger var indata till instruktionen ska hämtas eller var resultatet av instruktionen ska lagras. Exempel på en sats i språket:

    add r1,100,m(356) ! betyder: addera innehållet i register r1
                      ! och talet 100, lagra resultatet i
                      ! minnescellen med adressen 356

Här är instruktionen add, som alltid ska ha tre parametrar. De båda första parametrarna adderas och resultatet lagras i den tredje parametern. I exemplet är den första parametern ett register, den andra parametern en konstant och den tredje parametern en minnescell. Det finns fyra olika typer av parametrar:

1. Ett konstant värde: det angivna värdet används direkt som parameter. Man kan naturligtvis inte använda denna parametertyp som resultatparameter.
1. Register: ett av registren _R1_, _R2_, _R3_, _R4_ eller _R5_.
1. Minne: en av minnescellerna. Skrivs _M(adress)_, till exempel _M(356)_.
1. Minne indirekt: den minnescell vars adress finns i register _R1_, _R2_, _R3_, _R4_ eller _R5_. Skrivs _M(register)_, till exempel _M(R1)_. 

Det finns en femte parametertyp som kallas läge (engelska label, ”etikett”) och som bara används i samband med hoppinstruktioner. Ett läge är ett namn efterföljt av kolon som man skriver först på en programrad. I en hoppinstruktion är läget ”målet” för hoppet. Exempel:

    back:   sub  r1,1,r1
            ...
            jump back

<table>
  <tr><th>Kommando</th><th>Parametrar</th><th></th></tr>
  <tr>
    <td>move</td><td>p1, p2</td><td>Kopiera p1 till p2.</td>
  </tr>
  <tr>
    <td>add</td><td>p1, p2, p3</td><td>Addera p1 och p2, lägg resultatet i p3.</td>
  </tr>
  <tr>
    <td>sub</td><td>p1, p2, p3</td><td>Subtrahera p2 från p1, lägg resultatet i p3.</td>
  </tr>
  <tr>
    <td>mul</td><td>p1, p2, p3</td><td>Multiplicera p1 och p2, lägg resultatet i p3.</td>
  </tr>
  <tr>
    <td>div</td><td>p1, p2, p3</td><td>Dividera p1 med p2, lägg resultatet i p3 (heltalsdivision, resten kastas bort).</td>
  </tr>
  <tr>
    <td>jump</td><td>lab</td><td>Hoppa till lab, som ska vara ett läge.</td>
  </tr>
  <tr>
    <td>jpos</td><td>p1, lab</td><td>Hoppa till lab om p1 &gt;= 0, annars fortsätt exekveringen med nästa sats.</td>
  </tr>
  <tr>
    <td>jneg</td><td>p1, lab</td><td>Hoppa till lab om p1 &lt; 0, annars fortsätt.</td>
  </tr>
  <tr>
    <td>jz</td><td>p1, lab</td><td>Hoppa till lab om p1 = 0, annars fortsätt.</td>
  </tr>
  <tr>
    <td>jnz</td><td>p1, lab</td><td>Hoppa till lab om p1 &ne; 0, annars fortsätt.</td>
  </tr>
  <tr>
    <td>read</td><td>p1</td><td>Läs in ett talvärde, lagra det i p1 (detta är egentligen ett anrop till operativsystemet).</td>
  </tr>
  <tr>
    <td>print</td><td>p1</td><td>Skriv ut p1 (också detta är ett anrop till operativsystemet).</td>
  </tr>
  <tr>
    <td>stop</td><td></td><td>Avsluta exekveringen.</td>
  </tr>
</table>

I tabellen visas alla olika instruktioner som man kan använda i ME-datorn. p1, p2 och p3 är parametrar som kan vara av godtycklig typ.  
ME-datorn skiljer sig i en del avseenden från många moderna datorer, som är så kallade RISC-datorer (Reduced Instruction Set Computer). En sådan dator har man försökt göra så enkel som möjligt genom att hålla nere antalet olika instruktioner och genom att göra de instruktioner som finns så enkla som möjligt. Till exempel kanske det i en RISC-dator inte finns multiplikations  och divisionsinstruktioner, eftersom dessa operationer kan byggas upp med hjälp av andra instruktioner. Men framförallt är RISC-datorer inte så generella som ME-datorn när det gäller parametrar. Till exempel kräver en add-instruktion i en RISC-dator normalt att alla parametrarna är register.  
Med hjälp av de beskrivna instruktionerna kan man skriva både enkla och mer komplicerade program. Vi visar några exempel på program, där vi först skriver Javasatser och därefter mot svarande ME-satser. I alla exemplen utnyttjar vi i Javasatserna tre heltalsvariabler x, y och z. I ME-programmen lagras dessa variabler i minnescellerna M(0), M(1) respektive M(2).
Först visar vi ett exempel som bara innehåller tilldelningssatser och beräkning av ett aritmetiskt uttryck:

    x = 10;
    y = 20;
    z = 2 * (x + 1)   3 * y;

---

    move 10,m(0)      ! x = 10
    move 20,m(1)      ! y = 20
    add m(0),1,r1     ! r1 = x + 1
    mul 2,r1,r1       ! r1 = 2 * r1
    mul 3,m(1),r2     ! r2 = 3 * y
    sub r1,r2,m(2)    ! z = r1 -r2

De båda första Javasatserna motsvaras av var sin ME-sats. I den tredje Javasatsen finns en beräkning av ett aritmetiskt uttryck. Denna beräkning har vi varit tvungna att bryta ner i mindre delar som kan uttryckas med ME-satser. Vi använder register för att lagra mellanresultat. När man har ett program i högnivåspråk, till exempel Java, så är det kompilatorn som bryter ner komplicerade programstrukturer till satser i maskinspråket.  
Man kan också uttrycka mera komplicerade programstrukturer med hjälp av ME-satser, till exempel if-satser:

    Kommer snart

---

    Kommer snart

Notera att vi har varit tvungna att formulera om villkoren för att kunna uttrycka dem med ME  instruktioner. I satsen if (x > y) ... börjar vi med att räkna ut y   x och utför else-grenen omy   x är < 0,det vill säga om x är ≤ y.  
Till sist ska vi visa ett exempel på hur en while-sats i Java skrivs med hjälp av ME-satser. En for-sats kan ju uttryckas med hjälp av en while-sats, så en for-sats skriver man på ungefär samma sätt. Här beräknar vi summan y = 1+2+3+...+99:

    Kommer snart

---

    Kommer snart

När man har sett dessa exempel och tänkt sig in i hur arbetsamt det skulle vara att översätta ett större Javaprogram till ME-satser eller till någon annan dators assemblerspråk så uppskattar man antagligen att man normalt inte skriver program i sådana språk. De enda tillfällen då man själv måste skriva program i assemblerspråk är när man måste ha mycket nära kontakt med datorns hårdvara, till exempel i de inre delarna i ett operativsystem.  
Några avslutande anmärkningar om ME-datorns assemblerspråk:

* Man skiljer inte på små och stora bokstäver i program. En add-instruktion kan till exempel skrivas add, ADD, Add, . . .
* En kommentar inleds med ! och sträcker sig till slutet av raden (motsvarar Javas //).
* Man kan stoppa in blanka rader var som helst i ett program.

###Indirekt adressering – överkurs
I föregående avsnitt fanns inga exempel där vi utnyttjade den fjärde parametertypen, ”minne indirekt”. Detta beror inte på att denna parametertyp skulle vara oviktig — tvärtom är det nog så att den är den parametertyp som förekommer oftast i program som produceras av kompilatorer för högnivåspråk. Det beror på att minnet i sådana program inte kan adresseras statiskt med fixa adresser som M(0) eller M(1), eftersom kompilatorn inte kan förutsäga var en struktur kommer att finnas i minnet.  
Vi tar följande Javaklass som exempel:

    Kommer snart

Satsen x = x + 1 ska översättas till en add-instruktion: add ?,1,? där frågetecknen anger adres sen till x i minnet. Men man kan ju skapa flera A-objekt som hamnar på olika platser i minnet, som vi gör i följande satser:

    Kommer snart

I minnet kan det ut så här efter satsen A pa2 = new A() (detta är en förenklad bild):

    tabell

Vi ser att pa1.x här har adressen 920, pa2.x har adressen 921. Vi kan nu lösa problemet att adressera x i de olika objekten om vi ser till att vi, när vi kommer till metoden increment, alltid har adressen till det aktuella objektet (this-referensen) i ett bestämt register. Om vi antar att detta register är R3 kan additionsinstruktionen skrivas:

    Kommer snart

För att utföra operationen increment på ett objekt laddar man in adressen till objektet, till exempel pa1 eller pa2, i R3 och anropar metoden.  
Ett annat tillfälle då man måste utnyttja indirekt adressering är när man hanterar vektorer. Detta gäller även om en vektor är placerad på en bestämd plats i minnet: om man har en vektor v på en bestämd plats så känner man adresserna till alla elementen och kan därmed direkt adressera v[i] om i är en konstant. Men om i är en variabel så måste man beräkna i-värdet, addera det till vektorns startadress och lägga summan i ett register och till sist utnyttja indirekt adressering för att komma åt v[i].  
Vi visar hur det kan gå till i ett exempel:

    Kommer snart

Vi förutsätter här att vektorn v hamnar i minnet på adress 25 och framåt. Variabeln i lagrar vi i
￼register R1, variabeln sum i R3.

    Kommer snart

###Subrutiner – överkurs
En subrutin är ett programavsnitt som man kan hoppa till från olika platser i ett program. När man återvänder från en subrutin kommer man tillbaka till den plats varifrån man hoppade. När man hoppar till en subrutin säger man att man anropar subrutinen. Subrutiner kan ha parametrar dvs värden som man tar med sig till subrutinen när man anropar den. Subrutiner finns i de flesta programspråk även om benämningen kan variera mellan olika språk: metod, funktion, procedur, ...  
När det gäller subrutiner finns det tre problem som måste lösas:

1. Att hoppa till subrutinen. Detta är inte svårt; det gör man med en jump-instruktion. Proble  met blir att återvända från subrutinen; se punkt 3.
1. Att bestämma hur parametrarna ska föras över till subrutinen. Detta kan göras på olika sätt; här förutsätter vi att parametrarna lagras i register R2, R3 och R4. Man får alltså ha högst tre parametrar till en subrutin. Om subrutinen är en funktion så förutsätter vi att resultatet av funktionen förs tillbaka i register R1.
1. Att återvända till den plats i programmet varifrån subrutinen anropades. Detta löser vi genom att vi förutsätter att denna plats finns i register R5. Innan man hoppar till subrutinen måste man alltså ladda in anropsplatsen i detta register.

I nedanstående programavsnitt visar vi ett exempel med en subrutin write som kvadrerar och skriver ut innehållet i register R2. Subrutinen anropas från två platser i programmet, med parametervärdet 10 respektive 20.

            move 10,r2              ! parameter i första anropet
            move bk1,r5             ! plats att återvända till i första anropet
            jump write
    bk1:    move 20,r2              ! parameter i andra anropet
            move bk2,r5             ! plats att återvända till i andra anropet
            jump write
    bk2:    stop
    write:  mul r2,r2,r2            ! subrutinen: kvadrera parametern r2
            print r2                ! skriv ut r2
            jump  r5                ! hoppa tillbaka

Som synes har vi utökat assemblerspråket som beskrevs i tabellen med möjligheten att ladda in ett läge i ett register och att hoppa till det läge som finns i ett register.

Användning
-------------------------

    ./ME filename

Exempel

    ./ME examples/H7ss