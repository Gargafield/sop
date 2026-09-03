#import "@preview/metalogo:1.2.0" : LaTeX
#import "@preview/cetz:0.4.2"
#import "@preview/wordometer:0.1.5": word-count, total-words, total-characters
#import "@preview/ctheorems:1.1.3": *
#import "@preview/pavemat:0.2.0" : pavemat
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#show: thmrules
#show: word-count.with(exclude: (lorem))
// Total ord: #total-words ord og #total-characters karaktere, svarer til #context(int(state("wordometer").final().at("characters")) * 1.21 / 2400)-#context(int(state("wordometer").final().at("words")) / 350) normal sider

#let footcite(c) = [
  #footnote[#c]
]

#let matname(a) = math.bold(math.upright(a))

#let eq(a) = math.equation(a, block: true)

#let theorem = thmbox("theorem", "Sætning", fill: rgb("#eeffee"))
#let definition = thmbox("definition", "Definition", inset: (x: 1.2em, top: 1em), stroke: 1pt)
#let proof = thmproof("proof", "Bevis")
#let example = thmplain("example", "Eksempel").with(numbering: none)

#counter("figure").update(1)

#let URL_LINK_COLOR = color.rgb(0%, 0%, 80%)
#let DEFAULT_LINK_COLOR = color.rgb(50%, 0%, 0%)

#set bibliography(style: "apa")
#set cite(style: "apa")
#set text(lang: "da", region: "DK")
#set math.mat(delim: "[")
#set heading(numbering: "1.1")

#show cite: set text(fill: DEFAULT_LINK_COLOR);
#show ref: set text(fill: DEFAULT_LINK_COLOR)

#show link: it => {
  set text(fill: 
    if type(it.dest) == str {
      URL_LINK_COLOR
    } else {
      DEFAULT_LINK_COLOR
    }
  )

  it
}

#set figure(numbering: (a) => {
  str(counter(heading).get().first()) + "." + str(counter(figure).get().first())
})
#show figure: set figure(supplement: [Figur])
#show heading: it => {
  if (it.level == 1) {
    counter(figure).update(0)
  }

  if (it.numbering == none) {
    block(it.body)
  } else {
    block[
			#std.numbering(it.numbering, ..counter(heading).at(it.location()))
			#h(0.8em)
			#it.body
		]
  }
}

#set terms(hanging-indent: 0.1cm, indent: 0.3cm)

#set document(
  title: "Lineær Algebra I 3D-Grafik",
  author: "**** ****** ******",
  date: datetime(year: 2025, month: 12, day: 18)
)

#set page(
  paper: "a4",
  numbering: "I"
)

#let calc-margin(margin, shape) = if margin == auto {
  2.5 / 21 * calc.min(..shape)
} else {
  margin
}

// https://github.com/typst/typst/issues/4511#issuecomment-2221177350
#let redact(body, color: black) = box(hide(body), fill: color)
// redaction as in the issue
#let redactre(body, color: black) = {
  show regex("[^\s]"): it => redact(it, color: color)
  body
}

#let resume = [
Projektet kombinerer en kort historisk redegørelse med en grundig teoretisk gennemgang og en praktisk implementering, inklusive kode eksempler og visualiseringer af, hvordan lineær algebra anvendes til at skabe og manipulere 3D-grafik, og hvilken betydning den har for moderne computerspil. Gennem en kombination af matematisk teori og en praktisk eksempelimplementering i C++ med OpenGL demonstreres, hvordan 3D-punkter transformeres gennem en grafisk pipeline til 2D-pixels. Opgaven gennemgår både abstrakte begreber såsom vektorrum, lineære transformationer, matricer, homogene koordinater og konkrete matrixkonstruktioner, samt praktisk information om grafikkort og dets interfaces, og afsluttes ved en diskussion af begrænsninger og fremtiden inden for 3D-grafik.
]

#context {
  let margin = calc-margin(page.margin, (page.width, page.height))
  place(
    top + left,
    float: true,
    dx: -margin,
    dy: 2.5cm,
    {
      rect(
        fill: cmyk(100%, 60%, 60%, 60%),
        width: 100% + margin * 2,
        height: 6cm,
        pad({
          show title: set text(fill: white)
          {
            show title: set text(size: 1em)
            show title: set block(below: 0pt)
            title([Studieområdeprojekt])
          }
          {
            show title: set text(size: 2em)
            show title: set block(below: 0pt, above: 10pt)
            title()
          }
        }, left: 1cm, right: 2.5cm, top: 2.25cm, bottom: 2.5cm)
      )
    }
  )
  pad({
    grid(
      align: (right + horizon, auto, left + horizon),
      columns: (0.43fr, 1pt, 0.6fr),
      gutter: 3pt,
      pad({
        [#redactre[aaaa aaaaaaa aaaaaa] 3.t \
        NEXT - Københavns Mediegymnasium \ \ \
        _Vejledere: _ \
        
        _Matematik A_ - #redactre[aaaaaa aaaaa aaaaa] \
        _Programmering B_ - #redactre[aaaaa aaa] \ \
        18. december 2025
        ]
      }, right: 10pt),
      grid.cell(rect(fill: black, height: 240pt, width: 1pt), inset: (y: 10pt)),
      pad({
        set align(center)
        [*Resumé*]
        set align(left)
        [
          #resume
        ]

      }, left: 10pt)
    )
  }, top: 2.5cm)

  align(
    center,
  image("billeder/eksempel-app.png", height: 160pt)
  )
}

#pagebreak()

#counter(page).update(1)

#set page(
  footer: context [
    #set align(right)
    #counter(page).display(
      (index, ..other) => str(index) + " af " + str(other.at(0, default: 0)),
      both: true,
    )
  ]
)

#set page(
  paper: "a4",
  numbering: "1"
)

#show outline.entry: set text(fill: DEFAULT_LINK_COLOR)
#show outline.entry: it => {
  link(
    it.element.location(),
    it.indented(
      it.prefix(),
      box(grid(
        columns: (auto, 1fr, auto),
        column-gutter: 0.3cm,
        link(it.element.location(), it.element.body),
        {
          set text(fill: black)
          repeat([ #h(0.1cm).#h(0.1cm) ])
        },
        {
          set text(fill: black)
          it.page()
        }
      )),
    )
  )
}

#show outline.entry.where(level: 1): it => {
  show repeat: none
  v(0.2cm)
  strong(it)
}

#[
  #show heading: it => {
    set text(size: 1.3em)
    it
    v(-0.1cm)
  }

  #set footnote.entry(
    separator: none
  )
  #show footnote.entry: hide
  #show ref: none
  #show footnote: none
  
  #outline()
]

#pagebreak()

= Introduktion & Motivation

Mange spillere bevæger sig igennem komplekse 3D-verdener i videospil uden nogensinde at overveje, hvilke matematiske og teknologiske principper der muliggør sådanne oplevelser. Alle objekters placering består af et komplekst system af tandhjul, der sørger for at en 3D-position bliver til en 2D-pixel på ens skærm. Lineær Algebra er det centrale værktøj der muliggør dette, så objekter kan flyttes, roteres og projiceres. For selvom mange kender til det tryndy _raytracing_ i en tid, hvor det er blevet et krav for AAA-titler#footnote[Udtalt \\triple-a\\, er videospil med et stort budget, ofte produceret af industriens førende firmaer med fokus på banebrydende grafik og stor produktionsværdi] at komme så tæt på fotorealisme som muligt, er det nødvendigt at kigge tilbage på, hvad der bragte os ind i den tredje dimension til at starte med.

Denne opgave vil tage hånd om både den teoretiske og praktiske del af 3D-grafik med Lineær Algebra i en process kaldet _Rasterisering_. Først vil der være en kort historisk redegørelse af 3D-grafik igennem tiden, hvorefter den matematisk teoretisk del gennemgås, med fokus på matrixmultiplikation, rumlig transformering, projektioner, samt hvordan det relaterer til 3D-grafik. Derefter vil en eksempel implementering i C++ med OpenGL#footnote[Et modul til programmering af 2D- og 3D-grafik som virker på tværs af platforme og grafikkort, understøttet af alle grafikkort produceret af AMD, NVIDIA og INTEL] programmeres for at illustrere den praktiske anvendelse af teorien. Til slut vil metodens begrænsninger og lineær algebras generelle anvendelse diskuteres, med en perspektivering af fremtiden for 3D-grafik.

#pagebreak()
#box(width: 110%, height: 88%)[
#pad(left: 0.4cm)[= 3D-Grafik i Computerspil #footcite([@engine-history & @engine-evolution])]

#[
  Alene i 2025 er der blevet udgivet 19.000 computerspil på den populære internetbutik _Steam_ i følge #link("https://steamdb.info/stats/releases/")[SteamDB].
  Derfor må der kigges på nogle helt særlige spil igennem tiden, hvis der skal siges noget om 3D-grafikkens udvikling. I den følgende tidslinje, er en samling af de FPS-spil#footnote[*Første Person Skydespil*, hvor man deler øjne med hovedpersonen og bruger skydevåben], som alle har revolutioneret 3D-grafik og løftet standarden for spilindustrien på hver sin måde.
]

#let box-width = 9cm
#let figure-width = 9.1cm
#let figure-clip = 4.6cm

#let timeline-date(rel, date: datetime, above: true) = context {
  let title = [
    #set align(center)
    * #date.display("[year]") *
  ]

  let size = measure(title);
  let width = size.width + 100%
  if above {
    place(
      left,
      dx: -12pt - width,
      dy: rel,
      scope: "column")[
      #block(below: 3pt)[#title]
      #pad(left: 6pt - width, line(length: 18pt + width, stroke: 1.5pt))
    ]
  } else {
    place(
      left,
      dx: -12pt - width,
      dy: rel,
      scope: "column")[
      #pad(left: 6pt - width, line(length: 18pt + width, stroke: 1.5pt))
      #block(above: 3pt)[#title]
    ]
  }
}

#let timeline-event(rel, date: datetime, name: content) = context {
  let title = [
    #set align(right)
    *#name* \
    _ #date.display("[day]-[month]-[year]") _
  ]

  let size = measure(title);

  place(
    left,
    dx: -6pt,
    dy: rel,
    scope: "column")[
    #block(below: -size.height/2)[#title]
    #pad(left: 3pt, line(length: 6pt, stroke: 1.5pt))
  ]
}

#let image-crop(
  file,
  image-width: auto,
  width: auto,
  anchor: center,
  offset: 0pt,
  ..args,
) = {
  let clip = block.with(clip: true, width: width, ..args)
  let align = std.align.with(anchor)
  let offset = move.with(dx: offset)
  let img = image(file, width: image-width)
  clip(align(offset(img)))
}

#grid(
  columns: (auto, 4fr, 2fr),
  row-gutter: 10pt,
  column-gutter: (-70pt, -70pt),
  grid.vline(stroke: 1.5pt), {
    timeline-date(-10pt, date: datetime(year: 1990, day: 1, month: 1))
    timeline-event(25%, date: datetime(day: 5, month: 5, year: 1992), name: [Wolfenstein\ 3D])
    timeline-event(48%, date: datetime(day: 10, month: 12, year: 1993), name: [Doom])
    timeline-event(68%, date: datetime(day: 31, month: 5, year: 1996), name: [Quake])
    timeline-event(89%, date: datetime(day: 19, month: 11, year: 1998), name: box(width: 3cm)[Half-Life])
  },
  figure(
    box(width: box-width, stack(dir: ltr)[
      #image-crop("billeder/wolfenstein.jpg", anchor: center, image-width: figure-width, width: figure-clip)
    ][
      #image-crop("billeder/doom.jpg", anchor: center, image-width: figure-width -0.08cm, width: figure-clip)
    ]),
    caption: [Wolfenstein 3D og Doom af Id Software]
  ),
  [
    Wolfenstein, sammen med Doom, blev starten på gaming med PC'en#footnote[*Personlig Computer*, en computer designet til personlig brug, har ofte en skærm, tastatur og mus tilsluttet] og satte for alvor gang i FPS-genren.
    Disse spil brugte forenklede metoder, når de tegnede 3D-grafik, og er derfor pseudo-3D. Vægge blev tegnet i vertikale linjer baseret på hvor langt væk de var fra spilleren og monstre var 2D-flader. Disse metoder var hurtige, og nødvendige, da computere var langsomme og grafikkort ikke var udbredte. Metoden har dog flere begrænsninger, så som låst horisontalt perspektiv, alt i et område har den samme mængde belysning, og alle vægge skal være rette linjer. #footcite[@doom-limitations]
  ],
  {
    timeline-date(0pt, date: datetime(year: 2000, day: 1, month: 1), above: false)
    timeline-event(58%, date: datetime(day: 16, month: 11, year: 2004), name: box(width: 3cm)[Half-Life 2])
    timeline-event(78%, date: datetime(day: 13, month: 11, year: 2007), name: [Crysis])
  },
  figure(
    box(width: box-width, stack(dir: ltr)[
      #image-crop("billeder/quake.jpg", anchor: center, image-width: figure-width, width: figure-clip)
    ][
      #image-crop("billeder/goldsrc.jpg", anchor: center, image-width: figure-width, width: figure-clip)
    ]),
    caption: [Quake af Id Software og Half-Life af Valve]
  ),
  [
    Dette ændrede Quake på: der revolutionerede spilindustrien og bragte verdenen fuldkommen 3D og reel belysning! Dette blev muliggjort af bedre PC'er, men også mulighed for at bruge grafikkort.
    Nu består verdenen af polygoner der projiceres og tegnes på skærmen gentagende gange i sekundet for at simulere bevægelse. Det er denne proces, rasterisering, som vil blive undersøgt nærmere.
    Quakes spilmotor blev utrolig populær og eftertragtet af i spilindustrien, og blev derefter bl.a. brugt af Valves til deres populære Half-Life-serie.
  ],
  {
    timeline-date(-10pt, date: datetime(year: 2010, day: 1, month: 1))
    timeline-event(90%, date: datetime(day: 10, month: 12, year: 2020), name: [Cyberpunk\ 2077])
  },
  figure(
    box(width: box-width, stack(dir: ltr)[
      #image-crop("billeder/crysis.jpg", anchor: center, image-width: figure-width, width: figure-clip)
    ][
      #image-crop("billeder/cyberpunk.jpg", anchor: center, image-width: figure-width, width: figure-clip)
    ]),
    caption: [Crysis af Crytek og Cyberpunk af CD Projekt RED]
  ),
  [
    Efter Quake, bliver størstedelen af 3D-grafik beregnet på grafikkort. Dette giver nye muligheder som spiludviklere hurtigt gør brug af. Standarden for grafik i videospil udvikler sig hurtigt.
    10 år efter Quake, i Crysis, er der bløde skygger, global illumination#footcite[*Global Belysning*, indirekte belysning fra andre objekter medtages @enginge-architecture[11.3.3]], level of detail, reflektioner og ambient occlusion#footcite[*Omgivet Tillukning*, en metode der tilføjer skygger i hjørner og tillukkede områder af objekter]. I nyere tid, med spil som _Cyberpunk 2077_, bliver disse metoder kombineret med _pathtracing_, som prøver at simulere lys baglæns for at finde hvilket lys der ses af kameraet. 
  ]
)
]

#pagebreak()

= Den Teoretiske Del

I denne del, skal der beskæftiges med *Lineær Algebra*. Lineær Algebra forbindes ofte med løsning af lineære ligningsystemer, men da der i denne opgave anvendes rasterisering udlukkende i forbindelse med rumlig transformation, vil der kun blive redegjort for vektorrum, lineær transformationer, koordinatsystemer og matricer.

== Lineær Algebra #footcite[@au-algebra[Kapitel 1 & Bilag A]]

Der er mange matematiske begreber, der får nye navne og definitioner i lineær algebra. Det er derfor vigtigt at disse bliver afklaret. Lineær algebra bliver formuleret over et underliggende _legeme_, som er en mængde, hvor addition og multiplikation er defineret#footcite[Flere love og definitioner er pålagt @au-algebra[Definition A.1]].
Af de mange mulige mængder herunder de reelle tal $RR$ og de komplekse tal $CC$, vil der i denne opgave kun arbejdes med de reelle tal $RR$, da dette er tilstrækkeligt for den 3D-grafik der beskæftiges med. Da betegnelsen _legeme_ er relativt abstrakt, vil der i stedet bruges betegnelsen _skalar_ eller bare _tal_ i denne opgave.

== Vektorrummet #footcite[@au-algebra[Kapitel 5]]

#stack(dir: ltr, spacing: 1em)[
#box(width: 50%)[
Vektorer får ligeledes et nyt perspektiv i lineær algebra, hvor der arbejdes med _vektorrum_. Et vektorrum er defineret som en mængde af vektorer, der kan lægges sammen og multipliceres med en _skalar_#footcite[Flere love og definitioner følger @au-algebra[Definition 5.1]]. For eksempel, kan det tredimensionelle rumlige vektorrum, som der i denne opgave håndteres mest, beskrives som $RR^3$, hvor hvert element i rummet består af tre reelle tal, et for hver dimension. Disse egenskaber svarer til det som er lært i gymnasiet, og vil derfor også være sådan det behandles i resten af opgaven.
]][#box(width: 50%)[
  #definition[
    En vektor $arrow(a)$ af $n$'te-dimension er defineret, som en søjle af $n$ reelle tal $RR$, hvorved hvert element får tilnavnet $arrow(a)_1, arrow(a)_2, dots, arrow(a)_n$
    
    #example[En tredimensionel vektor
      #eq[$arrow(a)=vec(arrow(a)_1, arrow(a)_2, arrow(a)_3)$]
    ]

    #block(height: auto)
  ]
]]

== Koordinatsystemet #footcite[@enginge-architecture[s. 361] @mat-a[Kapitel 1.1] & @math-gamedev[Kapitel 2]]

#stack(dir: ltr, spacing: 1em)[
#box(width: 100% - 4cm)[
  Vektorrum adskiller den matematiske struktur fra valget af koordinatsystem, og der skal derfor vælges et koordinatsystem, før vektorer kan beregnes og repræsenteres.
  
  I gymnasiet arbejdes der næsten udelukkende med det kartesiske koordinatsystem, hvor akserne står vinkelret på hinanden. Der findes dog andre, bl.a. polære eller sfæriske koordinatsystem.
  
  For et tre dimensionelt kartesisk koordinatsystem, skelnes der desuden mellem venstre- og højrehåndet, baseret på hvordan akserne arrangeres i forhold til hinanden. Hvilken mulighed der vælges har betydning for opfattelsen og visualiseringen af koordinatsystemet og ændrer ikke vektorrummet, det kan dog have betydning for hvisse retningsbestemte operationer#footnote[Eksempelvis _krydsproduket_, som dog ikke anvendes i dnne opgave.].  
]
][
  #figure(
    image("billeder/koordinatsystem.png", width: 6cm),
    caption: [De tre planer]
  ) <figur-koordinatsystem>
]

Dette illustreres ved brug af _håndreglen_ og @figur-koordinatsystem. Ved at forme en knytnæve med venstrehånd og lade tommelfingeren pege i z-aksens positive retning, vil fingrespidsernes retning angive x-aksens positive retning, mens det første led fra knoerne peger i y-aksens positive retning. Koordinatsystemet i figuren er derfor venstrehåndet. Ligeledes kan denne test foretages med højrehånd. I denne opgave vil der både blive brugt en venstre og højrehåndet opfattelse af det kartesiske koordinatsystem, da dette er standarden i OpenGL, selvom det plejer at være udelukkende venstrehåndet.#footcite[@enginge-architecture[s. 362]]

== Lineær Transformation #footcite[@au-algebra[Kapitel 6]]

#stack(dir: ltr, spacing: 1em)[
#box(width: 50%)[
  Når vektorer skaleres, kan transformationen opfattes som en forstørrelse af hele rummet, hvor alle vektorer bliver forstørret eller forkortet. En sådan transformation beskrives i lineær algebra af afbildninger, som virker på vektorer i et vektorrum. Hvis en afbildning opfylder @lineær-definition, kaldes den for en lineær afbildning/transformation. En lineær afbildning er en udvidelse af den lineær funktion fra gymnasiet til at håndtere vektorrum, hvor den beskriver transformation mellem vektorrum.
]][#box(width: 50%)[
  #definition[
    En lineær afbildning $f$ mellem vektorrum bevarer addition og skalarmultiplikation for alle vektorere $arrow(a)$ og $arrow(b)$, samt skalarer $alpha$.

    #eq[$f(arrow(a) + arrow(b))=f(arrow(a)) + f(arrow(b))$]

    #eq[$f(alpha arrow(a)) = alpha f(arrow(a))$]

    #block(height: auto)
  ] <lineær-definition>
]]

== Matrix #footcite([@math-gamedev[Kapitel 3] ])

En lineær transformation kan repræsenteres som en matrix. Derfor bruges matricer ofte til at repræsentere rumlige transformationer, da de er effektive at beregne og gør det muligt at lave en kombination af transformering. Især i 3D-grafik bruges matricer ofte, og udgør derfor fokuset for resten af den teoretiske del.

#pad(left: -10%)[#box(width: 110%)[#stack(dir: ltr, spacing: 0.5em, box(width: 30%)[
#definition[
  En matrix $matname(M)_(n times m)$, er en tabel af tal med $n$ rækker og $m$ søjler.
  Når $n=m$ kaldes matrixen for kvadratisk. Hvert tal/element i matrixen får tilnavnet $matname(M)_(i j)$, for $i$ er tallets række og $j$ er dets søjle.

  #example[]

  #eq[$matname(M)_(3 times 3)=mat(
    matname(M)_11, matname(M)_12, matname(M)_13;
    matname(M)_21, matname(M)_22, matname(M)_23;
    matname(M)_31, matname(M)_32, matname(M)_33;
  )$]
  #block(height: 15pt)

]], box(width: 30%)[#definition[
  En identitets matrix $matname(I)_n$, er en kvadratisk matrix med størrelse $n$, dvs. $n$ søjler or rækker, hvor alle tal i diagonallen er lig med et:

  #eq[$matname(I)_(i j)=cases(
    1 "hvis" i = j,
    0 "hvis" i != j,
  )$]

  #example[]

  #eq[$matname(I)_3=
    pavemat(mat(
      1, 0, 0;
      0, 1, 0;
      0, 0, 1;
    ),
  )$]
  #block(height: 3pt)
] <identitet-definition>], [#box(width: 40%)[
  #definition[
    En vektor i et $n$-dimensionelt vektorrum, kan repræsenteres som en søjle matrix $matname(M)_(n times 1)$, med $n$ rækker og en søjle.

    #eq[$arrow(a)=vec(arrow(a)_1, dots.v, arrow(a)_n)=mat(arrow(a)_1; dots.v; arrow(a)_3;)$]

    Derudover er det værd at vide, at når en kvadratisk matrix $matname(M)$ multipliceres med en vektor $arrow(v)$ (repræsenteret som en søjlevektor), vil resultatet altid være en vektor, som har gennemgået den lineær transformation som $matname(M)$ repræsenterer.

    #block(height: auto)
  ] <vecmat-defintion>
]])]]

#stack(dir: ltr, spacing: 1em, box(width: 40%)[
  Matricer kan, ligesom vektorer, lægges sammen og multipliceres med en skalar, så længe at dimensionerne passer. Derudover har matricer også en særlig form for multiplikation, kaldet matrixmultiplikation, som er givet i @mult-definition. Matrixmultiplikation er særlig interessant, da den svarer til at kombinere lineære transformationer. Desuden, vil identitetsmatrixen, defineret i @identitet-definition, fungere som et neutralt element.
  Det er vigtigt at understrege, at matrixmultiplikation, i modsætning til normal multiplikation, generelt ikke er kommutativt, og rækkefølgen af transformationer har således en effekt for resultatet.

  #eq[$matname(M) times matname(G) != matname(G) times matname(M)$] 

], box(width: 60%)[
#definition[
  Givet to matricer $matname(M)_(n times m)$ og $matname(G)_(m times p)$ er produktet af matrix multiplikation endnu en matrix $matname(F)_(n times p)$, hvorved hvert tal i produktet er summen af produkterne mellem dets tilsvarende række i $matname(M)$ og søjle i $matname(G)$, og defineres matematisk således ved hjælp af sum symbolet $Sigma$:

  #eq[$matname(F)_(i j)=sum_(k=1)^m matname(M)_(i k) * matname(G)_(k j)$]

  #example[]

  #let m1 = $mat(matname(M)_11, matname(M)_12; matname(M)_21, matname(M)_22)$
  #let m2 = $mat(matname(G)_11, matname(G)_12; matname(G)_21, matname(G)_22)$
  #let m3 = $mat(matname(M)_11*matname(G)_11+matname(M)_12*matname(G)_21,matname(M)_11*matname(G)_12+matname(M)_12*matname(G)_22;
    matname(M)_21*matname(G)_11+matname(M)_22*matname(G)_21,matname(M)_21*matname(G)_12+matname(M)_22*matname(G)_22
    )$
  #eq[$matname(M)_(2 times 2) times matname(G)_(2 times 2)=matname(F)_(2 times 2) = \
    #pavemat(
      m1,
      fills: (
        "[0-0]": red.transparentize(80%),
        "[0-1]": red.transparentize(80%)
      )
    )
     times
     #pavemat(
      m2,
      fills: (
        "[0-0]": blue.transparentize(80%),
        "[1-0]": blue.transparentize(80%)
      )
    ) = \
    #pavemat(
      m3,
      fills: (
        "[0-0]": purple.transparentize(80%)
      )
    )
    $]
  #block(height: auto)

] <mult-definition>])

#theorem[
  Produktet af matrixmultiplikation for en kvadratisk matrix $matname(M)_(n times n)$ og identitets matrixen af samme størrelse $matname(I)_n$ vil altid være identisk til den originale matrix $matname(M)_(n times n)$.
  #eq[$matname(M)_(n times n) times matname(I)_n=matname(I)_n times matname(M)_(n times n)=matname(M)_(n times n)$]
] <sætning-identitet>

#proof[
  Ifølge definitionen af matrixmultiplikation fra @mult-definition, kan hvert element i produktet, mellem matrix $M$ og identitetsmatrix $I$ skrives som

  #eq[$(matname(M) times matname(I))_(i j)=sum_(k=1)^n matname(M)_(i k) * matname(I)_(k j)$]
  Derefter indsættes definitionen af identitetsmatrixen @identitet-definition og fås: 
  #eq[$(matname(M) times matname(I))_(i j)=sum_(k=1)^n matname(M)_(i k) * cases(
    1 "hvis" k = j,
    0 "hvis" k != j
  )$]
  Da alle led i summen er nul når $k != j$, kan de ignoreres dem, og der reduceres derfor, så led $k=j$ står tilbage. Derefter erstattes $k$ med $j$:

  #eq[$(matname(M) times matname(I))_(i j)=matname(M)_(i j) * 1=matname(M)_(i j)$]
  Da dette gælder for alle elementer, må det betyde at:
  #eq[$matname(M) times matname(I)=matname(M)$]
  Tilsvarende, kan det vises at hvilken hvilken side identitetsmatrixen opstår på ikke har en effekt, dvs. at:
  #eq[$matname(I) times matname(M)=matname(M)$]
  Sætningen er dermed bevist.
]

#theorem[
  Lad $matname(M)$ og $matname(G)$ være to kvadratiske matricer af størrelse $n times n$, som repræsenterer lineære transformationer i et $n$-dimensionelt vektorrum. For enhver vektor $arrow(v)$ i dette vektorrum, kan den samlede lineære transformation $F$, som opnås ved først at anvende $matname(G)$ og derefter $matname(M)$, fås ved matrixmultiplikation:

  #eq[$matname(F) arrow(v)=matname(M) times (matname(G) times arrow(v)) $]
] <sætning-kombination>

#proof[
  Ligesom i det tidligere bevis, anvendes definitionen for matrixmultiplikation givet i @mult-definition. Da en lineær transformation af en vektor resultere en søjlematrix (se @vecmat-defintion), foksueres der her på det $i$-te element.

  #eq[$(matname(M) times (matname(G) times arrow(v)))_i=sum_(k=1)^n matname(M)_(i k) * (matname(G) times arrow(v))_k$]

  Indsæt matrixmultiplikation definitionen for $matname(G) times arrow(v)$ og byt rækkefølgen af summationerne, hvilket er muligt fordi sum er kommutativt og associativt:
  
  #eq[$(matname(M) times (matname(G) times arrow(v)))_i&=sum_(k=1)^n matname(M)_(i k) * (sum_(j=1)^n matname(G)_(k j) * arrow(v)_j) \
        &=sum_(k=1)^n sum_(j=1)^n matname(M)_(i k) * matname(G)_(k j) * arrow(v)_j \
        &=sum_(j=1)^n sum_(k=1)^n matname(M)_(i k) * matname(G)_(k j) * arrow(v)_j \
        &=sum_(j=1)^n (sum_(k=1)^n matname(M)_(i k) * matname(G)_(k j)) * arrow(v)_j$]

  Det indre sum led, som følger matrixmultiplikation definitionen for $matname(M)$ og $matname(G)$, erstattes:

  #eq[$(matname(M) times (matname(G) times arrow(v)))_i&=sum_(j=1)^n  arrow(v)_j * (matname(M) times matname(G))_(i j) \
  &=((matname(M) times matname(G)) arrow(v))_i$]

  Da dette gælder for alle rækker $i$ i søjlematricen, og der fås derved:

  #eq[$matname(M) times (matname(G) times arrow(v))=(matname(M) times matname(G)) arrow(v)=matname(F) times arrow(v)$]

  Sætningen er dermed bevist.
]

#pagebreak()

== Rumlig Transformationer #footcite[@math-enginedev[s. 54 & s. 61]]

I 3D-grafik ønskes der ofte at flytte, skalerer og roterer objekter. Dette gøres selvfølgelig med matricer. Hvordan disse matricer ser ud vil der blive redegjort for her. Alle matricerne er kvadratiske og kommer til at blive brugt på vektorere.

Først og fremmest den mest simple: skaleringsmatricen. Denne kvadratisk matrice kan bruges til at forstørre eller formindske rummet. En skalering, som er lige på alle elementer, kaldes for uniform, hvilket er lig skalarmultiplikation for vektorer. Skaleringen er givet langs diagonallen.
#stack(dir: ltr, spacing: 0em)[#box(width: 50%)[
  #rect(radius: 4pt)[
    #stack(dir: ltr)[
    #align(center)[_Uniform_]
    #eq[$arrow(v)*alpha=mat(arrow(v)_1; arrow(v)_2; dots.v; arrow(v)_n) mat(alpha, 0, 0, 0; 0, alpha, 0, 0; 0, 0, dots.down, 0; 0, 0, 0, alpha;)$]
    ][
    #figure(
  cetz.canvas(length: 0.70cm, {
    import cetz.draw : *
    let grid_sidelength = 4;
    let p1 = (1, 1, 0, 0)
    let scale = cetz.matrix.transform-scale((0.5, 2, 0))
    let p2 = cetz.matrix.mul-vec(scale, p1)
    
    set-style(mark: (end: "straight"))
    grid((0, 0), (grid_sidelength, grid_sidelength), step: 1, stroke: gray)
    grid((0, 0), (grid_sidelength, grid_sidelength), step: 0.5, stroke: gray + 0.25pt)
    
    let b1 = green;
    rect((0, 0), (2, 2), stroke: b1.transparentize(50%), fill: b1.transparentize(80%))
    rect((0, 0), (3, 3), stroke: b1.transparentize(50%), fill: b1.transparentize(80%))

    line((2.1, 2.1), (2.9, 2.9))
    circle((2, 2), radius: 1pt, fill: black, name: "p1")
    circle((3, 3), radius: 1pt, fill: black, name: "p2")
    content((to: "p1", rel: (-0.25, 0.5)), [$v$])
    content((to: "p2", rel: (0.25, 0.5)), [$v'$])

    line((0, 0), (grid_sidelength, 0), stroke: red.transparentize(10%))
    line((0, 0), (0, grid_sidelength), stroke: blue.transparentize(10%))
  }))
  ]
  ]
]][#box(width: 55%)[
  #rect(radius: 4pt)[
    #stack(dir: ltr)[
    #align(center)[_Ikke Uniform_]
    #eq[$arrow(v) times mat(s_1, 0, 0, 0; 0, s_2, 0, 0; 0, 0, dots.down, 0; 0, 0, 0, s_2;)=mat(arrow(v)_1*s_1; arrow(v)_2*s_2; dots.v; arrow(v)_n*s_n)$]
    ][

  
    #figure(
  cetz.canvas(length: 0.70cm, {
    import cetz.draw : *
    let grid_sidelength = 4;
    let p1 = (1, 1, 0, 0)
    let scale = cetz.matrix.transform-scale((0.5, 2, 0))
    let p2 = cetz.matrix.mul-vec(scale, p1)
    
    set-style(mark: (end: "straight"))
    grid((0, 0), (grid_sidelength, grid_sidelength), step: 1, stroke: gray)
    grid((0, 0), (grid_sidelength, grid_sidelength), step: 0.5, stroke: gray + 0.25pt)
    
    let b1 = green;
    rect((0, 0), (1, 2), stroke: b1.transparentize(50%), fill: b1.transparentize(80%))
    rect((0, 0), (3, 1.5), stroke: b1.transparentize(50%), fill: b1.transparentize(80%))

    line((1.1, 1.9), (2.9, 1.6))
    circle((1, 2), radius: 1pt, fill: black, name: "p1")
    circle((3, 1.5), radius: 1pt, fill: black, name: "p2")
    content((to: "p1", rel: (-0.25, 0.5)), [$v$])
    content((to: "p2", rel: (0.25, 0.5)), [$v'$])

    line((0, 0), (grid_sidelength, 0), stroke: red.transparentize(10%))
    line((0, 0), (0, grid_sidelength), stroke: blue.transparentize(10%))
  }))
    ]
  ]
]]

Den anden lineære transformation, som der vil blive gjort brugt, er rotations matricer. Her vil der blive defineret for tredje-dimension, altså rundt om x-, y- og z-aksen. Rotationen er givet af en vinkel $theta$ rundt om aksen. Det er vigtigt at huske, at matrixmultiplikation ikke er kommutativt, og derfor har rækkefølgen for hvordan rotationerne sammensættes betydning.

#stack(dir: ltr, spacing: 1em)[#box(width: 33%)[
  #rect(radius: 4pt)[
    #box(width: 100%)[
    #align(center)[_X-Akse_]
    #eq[$matname(M)_("rot" x)(theta)=mat(1, 0, 0; 0, cos theta, -sin theta; 0, sin theta, cos theta;)$]
    ]
  ]
]][#box(width: 33%)[
  #rect(radius: 4pt)[
    #box(width: 100%)[
    #align(center)[_Y-Akse_]
    #eq[$matname(M)_("rot" y)(theta)=mat(cos theta, 0, sin theta; 0, 1, 0; -sin theta, 0, cos theta;)$]
    ]
  ]
]][#box(width: 33%)[
  #rect(radius: 4pt)[
    #box(width: 100%)[
    #align(center)[_Z-Akse_]
    #eq[$matname(M)_("rot" z)(theta)=mat(cos theta, -sin theta, 0; sin theta, cos theta, 0; 0, 0, 1;)$]
    ]
  ]
]]

#pad(top: -0pt)[== Den Fjerde Dimension #footcite[@math-enginedev[s. 65-68]] <den-fjerde-dimension>]

  Selvom meget kan gøres med skalering og rotering, sker det stadig ofte at et ønske om at flytte objekter opstår. Dette er dog ikke lineært, per @lineær-definition:, da lineær afbildning skal opfylde $f(arrow(0))=arrow(0)$. I stedet når der flyttes, kaldet translation, opstår ikke linearitet: $f(arrow(0))=arrow(t)!=0$

  Derfor kan denne rumlige transformering ikke repræsenteres med en $3 times 3$ matrix. Men hvad at tilføje en fjerde-dimension, kaldt for homogene koordinater, kan både translation samt andre rumlige transformeringer repræsenteres i en enkelt matrice.

  #stack(dir: ltr)[#box(width: 60%)[
Matrixen tager denne form, hvor $matname(M)$ er en anden rumligt transformation, såsom skalering, og $arrow(v)$ er det der ønskes at flyttes med. Bemærk, at de rumlige transformationer stadig kan kombineres med matrixmultiplikation.

  For vektorer, får de en fjerde akse $w$. Hvert element i vektoren skal divideres med denne værdi, før den kan repræsenteres i 3D. Derudover kan de vælges om en vektor skal behandle translation, ved at sætte $w$ til $0$ eller $1$. I tilfælde hvor vektorer repræsenterer en retning, vil $w$ blive sat til $0$ inden transformation, og omvendt hvis vektoren repræsenterer et punkt, vil $w$ sættes til $1$.

  ]][#box(width: 40%)[
    #definition[
      En $4 times 4$ matrix, med en lineær afbildning repræsenteret i matrix $M$ og translation med vektor $v$ har følgende form:

      #eq[$matname(F)=pavemat(
      mat(matname(M)_11, matname(M)_12, matname(M)_13, arrow(v)_1;
        matname(M)_21, matname(M)_22, matname(M)_23, arrow(v)_2;
        matname(M)_31, matname(M)_32, matname(M)_33, arrow(v)_3;
        0, 0, 0, 1;
      ),
      pave: #(
        (path: "SSSS", from: (0, 3)),
        (path: "DDDD", from: (3, 0))
      )
    )$]
    #block(height: auto)
    ]
  ]]

#pagebreak()

== Kort om koordinatsystemer #footcite[@enginge-architecture[Afsnit 5.3.9 & 11.1.4.1]] <kort-om-koordinat>

#stack(dir: ltr)[#box(width: 70%)[
Punkterne i 3D-grafik gennemgår før en lang række af transformationer de når skærmen. Indtil videre er der blevet opereret i _object space_. Her er punkter defineret i forhold til den geometri de udgør. Punkterne kan blive flyttet rundt med de tidligere beskrevet rumlige transformationer, i det der hedder _modelmatricen_, så de havner i _world space_. Det vil altså sige, at i spil hvor man løber rundt, forbliver karakterens repræsentation stille. Det er i stedet dets _modelmatrice_ som flytter den rundt i verdenen.

Tilskuerne skal have et indblik til den 3D-verden, hvilket gøres med et virtuelt kamera. Alt geometrien bliver sat i forhold til det i _camera space_ med en _viewmatrix_. Her alle punkterne i forhold til kameraet, så origo ligger ved kameraets position. Hvordan virtuelle kameraer og _viewmatrix_ virker vil ikke blive undersøgt i denne opgave.

]][#box(width: 30%)[
  #box(width: auto)[
    #figure(
      diagram(
        edge-stroke: 1pt,
        node-corner-radius: 4pt,
        edge-corner-radius: 8pt,
        mark-scale: 75%,
        spacing: (1em, 1em),

        node((0,1), [_Object Space_], stroke: 1pt + black, width: 80pt),
        node((0,2), [_World Space_], stroke: 1pt + black, width: 80pt),
        node((0,3), [_Camera Space_], stroke: 1pt + black, width: 80pt),
        node((0,4), [_NDC_], stroke: 1pt + black, width: 80pt),
        node((0,5), [_Screen Space_], stroke: 1pt + black, width: 80pt),

        edge((0,1), (0,2), "-|>"),
        edge((0,2), (0,3), "-|>"),
        edge((0,3), (0,4), "-|>"),
        edge((0,4), (0,5), "-|>"),
      ),
      caption: [Kæden af transformationer fra 3D-punkt til 2D-skærm]
    )
  ]
]]

Herfra bliver koordinatsystemet projekteret ind i en boks kaldet _NDC_ (_normalized device coordinates_), med en størrelse fra $-1$ til $+1$ på alle akser. Alle punkter der projekteres uden for boksen kan ikke ses af det virtuelle kamera. I dette koordinatsystem udgør $(0, 0)$ centeret for skærmen, hvilket er det sidste koordinatsystem.

== Projektionsmatrixen #footcite[@enginge-architecture[Afsnit 11.1.4.2]]

I 3D-grafik er det ikke tilstrækkeligt blot at flytte, skalerer og roterer punkter. For at kunne vise et tre-dimensionelt punkt på en 2D-skærm, skal der udføres en projektion.

Det er projektionsmatrixens formål at gå fra at 3D-punk til NDC. Der bruges oftes to af de følgende projektioner: perspektiv eller ortografisk. Forskellen er blot om geometriens afstand til kameraet har betydning for dets størrelse. Projektionsmatrixen nær- og fjernplan udgør hvor 'fokuset for kameraet', alt inden og efter er uden for rækkevide.

Ved anvendelse af homogene koordinater kan også projektion formuleres som en matrixtransformation. Projektionsmatricen er derfor ligeledes en $4 times 4$ matrix, som anvendes på samme måde som de øvrige rumlige transformationer. I praksis indgår projektionsmatricen som det sidste led i kæden, efter objektets position og orientering er fastlagt. Hvordan projectionsmatrixerne er blevet til vil ikke blive undersøgt i denne opgave.

#box(width: 100%)[
  #figure(
    [
      #stack(dir: ltr)[#box(width: 30%)[
        #align(center, [_Perspektiv_])
        #image("billeder/perspektiv.png")
      ]][
        #box(width: 33%)[
          #align(center, [_Ortografisk_])
          #image("billeder/ortografisk.png")
        ]
      ][
        #box(width: 33%)[
          #align(center, [_NDC_])
          #image("billeder/ndc.png")
        ]
      ]
    ],
    caption: [Illustration af perspektiv og ortografisk projektioner, samt NDC \ _Billeder stammer fra følgende #link("https://www.songho.ca/opengl/gl_projectionmatrix.html")[ hjemmeside]_]
  )
]

#definition[
  Givet nær-planets venstre $l$, højre $r$, top $t$ og bund $b$. Samt afstanden til nær- $n$ og fjernplanet $f$. Kan en perspektivmatrix $matname(P)$ og en ortografiskmatrix $matname(O)$ opstilles således.
  #stack(dir: ltr)[#box(width: 50%)[
    #eq[$matname(P)=mat(((2n)/(r-l)), 0, 0, 0;
    0, ((2n)/(t - b)), 0, 0;
    ((r+l)/(r-l)), ((t+b)/(t-b)), (-(f+n)/(f-n)), (-(2n f)/(f-n)); 0, 0, -1, 0)$]
  ]][#box(width: 50%)[
    #eq[$matname(O)=mat(((2n)/(r-l)), 0, 0, (-(r+l)/(r-l));
    0, ((2n)/(t - b)), 0, (-(t+b)/(t-b));
    0, 0, (-(2)/(f-n)), (-(f+n)/(f-n));
    0, 0, 0, 1)$]
  ]]

  #block(height: auto)
]

== Delkonklusion

I denne teoretiske gennemgang er fundamentet for 3D-grafik og rasterisering med lineær algebra blevet lagt. Der er blevet redegjort for grundprincipperne i lineær algebra, og hvordan nogle objekter differentiere sig fra gymnasie-pensum. Der er særligt blevet lagt væk på matricer, og deres egenskab til repræsenterer lineære transformationer.

= Den Praktiske Del

Med denne teori under armen, skal der nu kigges nærmere på hvordan dette anvendes. Dette vil blive gjort i den følgende rækkefølge: _hardware_ $arrow.filled$ _interface_ $arrow.filled$ _eksempel applikation_.

== Grafikkortet #footcite[@enginge-architecture[Kapitel 4.2 & 11.2]]

#stack(dir: ltr)[#box(width: 70%)[
  Overgangen fra pseudo-3D i _Doom_ til fuld 3D-grafik i _Quake_ blev starten på et tegnologisk fremskridt, der gav plads til nye komponenter i PC'en. _Quake_ blev netop et af de første store hits som understøttede grafikkort#footcite[#link("https://en.wikipedia.org/w/index.php?title=Quake_(video_game)&oldid=1327425967")[Quake (video game) - Wikipedia]]. Dette markerede starten på grafikkortets centrale rolle i 3D-grafik. Men hvad er et grafikkort egentligt?
  
  Et grafikkort, også kendt som en *GPU* (_graphics processing unit_), er et specialiseret stykke hardware designet til at beregne store mængder af data parallelt. I moderne grafikkort består hver microchip#footcite[*Mikrochip*, er et integreret kredsløb skabt til f.eks. at beregne eller andet digitalt arbejde] af flere tusinde mindre beregningsenheder, kaldet _kerner_. Et eksempel på denne opbygningen for et moderne grafikkort ses i @figur-grafikkort.

  Alle disse _kerner_ kan programmeres på en måde, der minder om CPU'en (_central processing unit_). Dog skal alle kernernene programmers til det samme. Derfor egner grafikkort sig til ensartet uafhængigt arbejde, som kan distribueres til de mange kerner. En typisk vil disse kerner lave beregninger på decimal tal, repræsenteret af _floating point_-numre digitalt.

]][#box(width: 40%)[
  #figure(
    image("billeder/grafikkort.jpg"),
    caption: [Overblik af NVIDIA's GA102 (Ampere) Mikrochip#footcite[#link("https://www.tomshardware.com/news/infrared-photographer-photos-nvidia-ga102-ampere-silicon")[IR Photographer Shares Die Shots of Nvidia 3000 Series GA102 Silicon - Tom's Hardware]]]
  ) <figur-grafikkort>
]]

  Inden for 3D-grafik er dette især relevant for de tidligere nævnte _lineære transformationer_, da denne operation er enormt effektiv at beregne i parallelt. Derfor kan grafikkort indeholde specielle enheder, kaldt _tensors_, der er optimeret til udelukkende matrixmultiplikation.

_Flops_ (_floating point beregninger pr. sekund_), kan bruges til at måle kraften af et grafikkort. 
  Grafikkort som kørte _Quake_ havde _MFLOPS_ ($10^6$, million), mens moderne grafikkorts beregningskraft måles i _TFLOPS_ ($10^12$, billion). 

== Grafikpipelinen #footcite[@enginge-architecture[Afsnit 11.2.4]]

Processen fra 3D-geometri bestående af objekter til et færdigt billede kaldes for _pipelinen_ og udføres på grafikkortet. De programmerbare dele af pipelinen skrives i _shaders_, som udføres i parallel. Den følgende figur illustrere hvilke dele af pipelinen der vil blive kigget nærmere på i denne opgave.

#let colors = (maroon, olive, eastern)

#figure(
pad(left: -12.5%)[#box(width: 110%)[
#diagram(
	edge-stroke: 1pt,
	node-corner-radius: 4pt,
	edge-corner-radius: 8pt,
  spacing: (2em, 1em),

	node((1,0), [_Instruktioner_ gives af CPU'en ved hjælp af et interface. GPU'en kan ikke selv inteagere med operativsystemet.], stroke: 1pt + black, width: 200pt),
	node((1,+1), [En _Vertex Shader_, køres i parallelt på alle punkter. Et oplagt sted at udføre rumlige transformationer.], stroke: 1pt + black, width: 200pt),
	node(enclose: ((2,0), (2, 1)), [#rotate(-90deg, box(width: 3cm)[_Internt Arbejde_])], stroke: 1pt + black, height: 120pt, width: 30pt, shape: rect),
	node((3,0), [_Fragment Shaderen_ fylder og tegner alt geometrien. Farver og _textures_ lægges også til her.], stroke: 1pt + black, width: 200pt),
	node((3,1), [_Frame Bufferen_, som indeholder resultatet, sendes ud af f.eks. HDMI til en tilsluttet skærm eller operativsystem.], stroke: 1pt + black, width: 200pt),

  edge((0,0), (1,0), "-|>", [_Start_], label-pos: -0.6, label-side: center),
  edge((3,1), (4,1), "-|>", [_Slut_], label-pos: 1.6, label-side: center),

  edge((1,0), (1,1), "-|>"),
  edge((1,1), (2,1), "-|>"),
  edge((2,0), (3,0), "-|>"),
  edge((3,0), (3,1), "-|>"),
)]],
  caption: [Illustration af en mulig grafik pipeline]
)
== Grafik Interface Krigen #footcite[@graphic-apis]

Som antydet i figuren ovenover, starter programmeringen af grafikkort med CPU'en. Kommunikationen mellem CPU'en tager følgende form:

#pad(left: -13%)[#box(width: 115%)[
#diagram(
	edge-stroke: 1pt,
	node-corner-radius: 4pt,
	edge-corner-radius: 8pt,
  mark-scale: 75%,
  spacing: (1em, 1em),

	node((1,0), [_Proces/Applikation_ \ Kører på et operativsysteme.], stroke: 1pt + black, width: 140pt),
	node((2,0), [_Interface/API#footcite[*Applikation Programmerings Interface* eller *programmeringsgrænseflade*, er en standardiseret mellemmand, som kan facilitere kommunikation mellem to programmer.]_ \ Programmering af grafikkortet.], stroke: 1pt + black, width: 155pt),
	node((3,0), [_Driver_ \ Kommunikere med GPU'en], stroke: 1pt + black, width: 136pt),
	node((4,0), [_GPU'en_ \ Udføre kommandoer.], stroke: 1pt + black, width: 110pt),

  edge((1,0), (2,0), "-|>"),
  edge((2,0), (3,0), "-|>"),
  edge((3,0), (4,0), "-|>"),
)]]

GPU'en og Driveren håndteres af af grafikkort fabrikanten. Centralt for dette er dog at driverne ofte er udviklet til et særligt operativsystem. Lige netop operativsystemet, og dets forskelle viser sig at blive besværligt for grafikkort. For i modsætning til CPU'er, hvis instruktioner ofte er standardiseret, f.eks. _x86_, _ARM_ og _amd64_, så er der et vel af forskellige interfaces til programmeringen af GPU'er. Der findes mange åbne og lukkede standarder, så her er de mest mærkbare:

/ OpenGL: blev standardiseret i 1992 og derefter senere udviklet af Khronos Group. Dette var den første reele standardt til graffikort, eller 3D-acceleratorer som de blev kaldt den gang. OpenGL manger dog nogle moderne ønsker, såsom raytracing, men er til gengæld understøttet af stort set alle grafikkort. Dog bliver denne standardt ikke udviklet længere og er blevet afløst af _Vulkan_

/ Vulkan: er også et interface standardiseret af Khronos Group. Dette interface giver langt mere eksplicit kontrol og er derfor en smule indviklet, mod at være mere kraftfuld, og gør det muligt for udviklere at optimere bedre. Vulkan har har flere moderne funktioner en OpenGL, fx. raytracing.

/ DirectX: er, i modsætning til de tidligere nævnte, fuldkommen eksklusivt interface og er udviklet af _Microsoft_. Det er derfor udlukkende understøttet i _Windows_ og til _Xbox'en_

/ Metal: er _Apples_ eksklusive interface, som skal erstatte OpenGL på deres operativsystemer.

Det er _OpenGL_ der vil blive brugt til eksempel programmet, da det understøttes af flest mulige platforme og har mest udbredt understøttelse. _Vulkan_ kunne også bruges, men dets explicite natur gør at eksempel programmet kunne fylde op til 9 gange så mange linjer#footcite[@graphic-apis[7:46-7:51]].   

== Implementeringsmetode #footcite[@enginge-architecture[Afsnit 3.1.2]]

For at interagere mod OpenGL skal der først og fremmest skrives et program til CPU'en. Dette program skal håndtere flere ting: skabe et vindue til brugeren, opsætning af OpenGL og give kommandoer til GPU'en.

Der er mange forskellige programmeringssprog som kan bruges. De differentieres ofte baseret på om de er _kompileret_ eller _fortolket_. Et kompileret programmeringssprog kræver at udvikleren bruger en _oversætter_ til at gå fra den læsbare tekst til binært maskinsprog. I kompilerede sprog, er det ofte et krav, at programmøren selv holder styr på computerens hukommelse. Dette er i modsætning til fortolket sprog, hvor teksten bliver behandlet af et andet program når koden skal køres. Fortolkede sprog har ofte en _garbage collector_, som håndtere programmets hukommelse. Kompilerede sprog er ofte hurtigere en fortolkede sprog, men kræver at koden bliver oversat til de platforme hvor det skal kører.

Derfor er det oplagt at bruge det kompilerede programmeringsproget _C++_, som originalt blev udviklet af danskeren Bjarne Stroustrup. Dette sprog er baseret på 'moderen' af alle programmeringssprog _C_, og kan  derfor bruges som en udvidelse af det. C++ er fordelagtigt til computergrafik da det giver programmøren tæt kontrol og er designet til at lave høj hastigheds applikationer. Desuden har dette været det mest bruge programmeringssprog i spilindustrien.

I denne opgave anvendes C++ udelukkende som et redskab til at interagere med OpenGL. Derfor vil der ikke blive redegjort for sprogets syntaks og opførsel. Dertil gøres der opmærksom på at der bliver gjort brug af #link("https://www.glfw.org/")[_glfw_] og #link("https://github.com/Dav1dde/glad")[_glad_] til at skabe et vindue og håndtere opsætningen af OpenGL.

Derudover bruges programmeringsproget _GLSL_ (_OpenGL shader language_), til at skrive shadersne fra _pipelinen_.

Den grundlæggende OpenGL-opsætning er baseret på en gennemgang beskrevet i @learn-opengl, som primært anvendes til initialisering af interfacet. Kodegennemgangen vil derfor fokuserer på hvordan de matematiske principper bindes sammen med OpenGL.

== Kodegennemgang

#stack(dir: ltr)[#box(width: 60%)[
  Eksempel applikationen, kommer til at vise de rumlige transformationer, som der blev redegjort for i den teoretiske del. Altså de følgende matricer: skalering, rotation og translation.

  For at illustrere disse, vil der blive tegnet 3 trekanter ved siden af hinanden. Den første, til venstre, vil blive skubbet frem og tilbage på z-aksen mens den gør brug af en perspektivprojektering. Den midterste, bil blive skaleret og rotere rundt. Og den til højre skubbes også på z-aksen, ligesom den til venstre, men bruger derimod en ortografisk projektion. Dette ses i @figur-eksempel. Bemærk dog, at det forventede resultat for den højre trekant, er at der sker intet visuelt med tiden.
  
]][#box(width: 40%)[
  #figure(
    image("billeder/eksempel-app.png"),
    caption: [Eksempel applikationen]
  ) <figur-eksempel>
]]

Der er mange måder, hvorpåat matricer kan implementeres på grafikkort med OpenGL. I denne opgave vil der tages udgangspunkt i CPU'en med modulet #link("https://glm.g-truc.net/")[_glm_].

=== Vertex Shader

Der vil blive startet med at gennemgå, hvordan _glm_ kan bruges. Først og fremmest skal der skrives  en vertex shader i _GLSL_. Vertex shaderen bliver kørt på alle de punkter som tegnes, og er derfor stedet hvor der laves rumlige transformeringer. Sådan ser koden ud:

#stack(dir: ltr, spacing: 1em)[#box(width: 45%)[
```vs
layout (location = 0) in vec3 inPos;
layout (location = 1) in vec3 inColor;

uniform mat4 projection;
uniform mat4 model;

out vec3 outColor;

void main()
{
   gl_Position = projection 
                *  model
                * vec4(inPos, 1.0f);
   outColor = inColor;
}
```
]][#box(width: 60%)[
  Der defineres først hvilket data som shaderen forventer. Her er de to tre-dimensionelle vektorer, hvor den ene repræsentere punktet der skal transformereres og den anden en RGB-værdi til farven af punktet.
  Derefter specificeres to global matricer, som skal bruges til transformationen, _projection_ og _model_ som nævnt i @kort-om-koordinat

  I _main()_, skrives instruktionerne der skal udføres på grafikkortet.
  Her kan det ses at variablen _gl_Position_, sættes til at være resultatet af matrixmultiplikation for først modelmatrixen og punktet, og derefter det sidste led, projectionsmatrixen. _gl_Position_ er derved det originale punkt i _NDC_. Som tidligere nævnt er OpenGL både venstre- og højrehåndet, hvor _NDC_ er venstre og _world space_ er højre.
]]

Da der arbejdes med homogene koordinater sættes det fjerde komponent til at være `1.0`, ligesom beskrevet i @den-fjerde-dimension. Læg mærke til rækkefølgen for multiplikationen. Byttes der rundt på den får man ikke det korrekte resultat.

=== Applikation

Inden der kan gives kommandoer til OpenGL, skal der defineres nogle konstanter. Bemærk dog at en dynamisk liste i C++ heder en `std::vector`, og ikke repræsenterer et punkt.

```cpp
// Forskydningen for de tre trekanter
std::vector<glm::vec3> trianglePositions = {
    glm::vec3(-0.5f, 0.0f, 0.0f),
    glm::vec3(0.0f, 0.0f, 0.0f),
    glm::vec3(0.5f, 0.0f, 0.0f)
};

// Perspektiv- og ortografiskmatrix
// Begge funktioner specificerer en et nær-plan med størrelsen -1 til 1
// og at nær- og fjernplanet er henholsvis 1 og 10 væk fra origo.
glm::mat4 perspective = glm::frustum(-1.0f, 1.0f, -1.0f, 1.0f, 1.0f, 10.0f);
glm::mat4 orthographic = glm::ortho(-1.0f, 1.0f, -1.0f, 1.0f, 1.0f, 10.0f);

// Tiden siden starten af programmet blev kørt.
// Denne værdi vil blive opdateret løbede
float time = (float)glfwGetTime();


```

I en _while_-lykke, som kører hver frame, kan der specificeres hvordan indholdet af vinduet skal tegnes. Til de tre trekanter, er der tidligere blevet specificeret deres forskydning i en liste af vektorer.  Denne liste itereres over for at tegne hver trekant og tager følgende form:

#show raw: it => context {
  show regex("#\\[.*?\\]"): match => context {
    let inner = match.text.slice(2, -1)
    
    eval(inner, mode: "markup")
  }
  it
}


```cpp
for (size_t i = 0; i < trianglePositions.size(); ++i) {
  // Indhold
}
```

Selve indholdet er brudt ned i dele for at gøre gennemgangen lettere. Der skal først og fremmest specificeres hvilken projektion der skal bruges til trekanten.

```cpp
// Der startes med at definere en tom #[$ 4 times 4$] matrix
glm::mat4 projection;
switch (i) {
    case 0:
        projection = perspective;
        break;
    case 1:
        // Som tidligere bevist i #[@sætning-identitet] har identitets matrixen ingen effekt i sig selv
        projection = glm::identity<glm::mat4>();
        break;
    case 2:
        projection = orthographic;
        break;
}
glUniformMatrix4fv(projectionLoc, 1, GL_FALSE, glm::value_ptr(projection));
```

Her bliver der gjort brug af en _switch_-erklæring. Som input tager den trekantens nummer `i`, hvor `0` er trekanten til venstre og `2` er den til højre.
Når koden gøres tjekkes inputet og den rette `case` vil blive fundet og kørt.
Inde i hver `case`, sættes værdien for projekteringen. Tilslut bliver matricen sendt til vertex shaderen. Derefter mangler blot modelmatricen:

```cpp    
// Der startes med at definere en #[$ 4 times 4$] identitetsmatrix
glm::mat4 transform = glm::identity<glm::mat4>();

/* Det er vigtigt at betragte række følgen af de følgende matrixmultiplikationer.
    Da ønsket er først at skalere trekanten, derefter rotere rundt om sig selv,
    og til slut forskydes, bliver række følgen af matrixmultiplikationerne
    behandlet omvendt, pr. #[@sætning-kombination]. Translationsmatrixen multipliceres først
    i kombinationen, men udføres til sidst i helheden af transformationen.
    Hver transformation gør brug af det sidste resultat og overskriver det. */

// Hvis det er den venstre eller højre trekant
if (i == 0 || i == 2) {
  // Den prædefinerede forskydning lægges sammen med en z-afstand givet tiden.
  float zdistance = sin(time) * 2.0f - 3.0f;
  transform = glm::translate(
    transform, 
    trianglePositions[i] + glm::vec3(0.0f, 0.0f, zdistance));
} else { // Hvis det hverken er venstre eller højre, så må det være midten

  // Translation med den prædefinerede forskydning for netop denne trekant
  transform = glm::translate(transform, trianglePositions[i]);

  // Rotation rundt om Z-aksen. Vinklen er baseret på tiden, hvor hver trekant
  // er forskudt med 1 sekund, så det tager 6 sekunder for en fuld omdrejnings.   
  float angle = (time + (float)i) * glm::radians(60.0f);
  transform = glm::rotate(transform, angle, glm::vec3(0.0f, 0.0f, 1.0f));

  // Skaleringen er også givet over tid.
  // Her specificeres det at skaleringen er på alle akser.
  float scale = sin(time + i) * 0.5f + 1.0f;
  transform = glm::scale(transform, glm::vec3(scale, scale, scale));
}

// Værdien af matricen sendes til GPU'en
glUniformMatrix4fv(modelLoc, 1, GL_FALSE, glm::value_ptr(transform));
```

Nu da både model- og projektionsmatrixen er blevet sat for denne trekant, skal OpenGL blot havde nogle punkter at tegne:

```cpp
glDrawArrays(GL_TRIANGLES, 0, 3);
```

Disse punkter er blevet prædefineret, og kan genbruges til hver trekant. Genbrugen af geometri, som udelukkende differentiere i modelmatrix, kaldes for _instancing_ indenfor 3D-grafik. 

== Delkonklusion

Resten af koden af udeladt, da det ikke omfatter lineær algebra, men kan alligevel blive fundet på #link("https://github.com/Gargafield/sop")[GitHub] eller på #ref(<bilag>, form: "page"). Desuden kan en video af det endelige resultat blive set på #link("https://youtu.be/KG3QGPtaQp8")[YouTube].

_glm_ gør heldigvis den lineære algebra meget tilgængelig for programmører, men den underliggende teori er stadig den samme. Under de simple funktionskald såsom `glm::frustum`, `glm::translate` og `glm::rotate` konstrueres fortsat $4 times 4$ matricer, som svarer direkte til de rumlige transformationer, der tidligere er blevet redegjort for. Programmet virker desuden som en opfølgelse på beviserne fra teorien, da det viser deres anvendelse i praksis.

Samtidigt er det tydeligt, at selvom biblioteker som glm abstraherer den matematiske kompleksitet fra programmøren, så er en grundlæggende forståelse af lineær algebra stadig nødvendig for at kunne anvende funktionerne korrekt.
Uden kendskab til transformationernes betydning og rækkefølge ville det være vanskeligt at forudsige eller kontrollere det visuelle resultat.

Eksemplet er bevidst holdt simpelt og fokuserer udelukkende på den lineære algebra forbundet med _modeltransformation_ og projektion. For at det blev et komplet spil, vil det også kræve virtuelt kamera. Dette er dog uden for opgavens omfang.

= Diskussion

I det foregående er det blevet vist, hvordan lineær algebra danner det matematiske grundlag for rumlige transformationer i 3D-grafik, og hvordan disse principper kan implementeres i praksis ved hjælp af interfaces og moduler såsom OpenGL og glm. I dette afsnit diskuteres vil lineær algebras begrænsninger samt alternative tilgange til anvendelse af lineær algebra i grafiske applikationer og andre sammenhæng.

== Styrker

Den fundamentale styrke ved lineær algebra ligger i dens mulighed for at beregnes parallelt. Derudover, som demonstreret i @sætning-kombination, kan matricers egenskab til at sammensætte flere lineære transformation, reducerer mængden af beregninger betydeligt.

Dette gør lineær algebra fuldkommen nødvendigt når der er tale om realtids 3D-grafik. For at ramme gameres mindstekrav på 60 _FPS_#footcite[*Billeder pr. sekund*, en måleenhed for hvor mange gange et vindue/spil bliver tegnet i sekunder. Kan, ligesom _TFLOPS_, bruges til at måle hvor kraftfuld en GPU er.], får grafikkortet blot 16 ms pr. billede. Så når der er millioner af punkter, som skal transformeres hvert sekund, er det afgørende at operationerne kan distribueres til grafikkortets tusinder af kerner. Den uafhængige natur af lineære transformationer betyder, at hvert punkt kan behandles parallelt, hvilket er præcis den type arbejde som GPU'er er optimeret til.

Også selvom der ikke skal tegnes geometri, bliver lineær algebra brugt i mange andre sammenhæng for punkter skal transformeres, f.eks. ens browser, tegneprogrammer og fysikmoterer.

== Begrænsninger

Selvom lineær algebra er kraftfuld og rasterisering har været brug i snart 30 år, har metoden også klare begrænsninger.

Den mest åbenlyse er, at lineære transformationer per definition, nødvendigvis er lineære. Dette betyder, at visse typer af deformationer, såsom bøjning, vridning eller ikke-uniform skalering langs kurver, ikke kan repræsenteres direkte i en $4 times 4$ matrix.

En anden begrænsning ved rasterisering, som hele denne opgave bygger på, er dens fundamentale tilgang til belysning og skygger. Rasterisering behandler hver trekant isoleret og kan derfor ikke naturligt håndtere skygger, refleksioner, refraktioner eller indirekte belysning uden omfattende arbejde. Dette betyder i praksis, at naturlig korrekt belysning er stort set umuligt. Derfor bruger spil ofte mange tricks og illusioner til at implementere dette, såsom at 'bage' skygger ind i verdenen.

Den mest almindelige måde at lave realtids skygger med rasterisering hedder _shadowmapping_. I denne metode, vil verdenen blive tegnet fra hver lyskildes perspektiv. Alt geometri mellem lyskilden og det uendelige må kaste en skygge, hvilket bliver tegnet ind i en seperat texture. Denne texture kan derefter projekteres fra lyskildens perspektiv, så den ses som skygge fra det virtuelle kamera. #footcite[@enginge-architecture[Afsnit 11.3.3]]

== Pathtracing

En mere radikal alternativ tilgang er at kombinerer rasterisering med en helt anden tilgang. Pathtracing, også kendt som raytracing, som demonstreret i Cyberpunk 2077, ændrer fundamentalt på hvordan belysningen forgår i spillet. Trekanter bliver stadig rasterized, da det simpelthen ikke giver mening at bruge en anden metode til tegningen af geometri. Dog prøver metoden at simulere lysstrålernes vej gennem verden baglæns fra kameraet, resultatet af dette bruges til at belyse geometrien. Lineær algebra spiller stadig en central rolle her, da strålers retninger repræsenteres som vektorer og deres interaktion med overflader kræver transformation af normalvektorer. Forskellen ligger i at hver pixel beregnes baseret på hele scenens geometri, ikke kun de synlige overflader. Selvom teknologien er udviklet, så er det stadig kun de bedste (og dyreste) forbuger grafikkort som kan beregne dette alternativ.

I ikke-realtids sammenhæng bruges pathtracing ofte til at tegne billeder, på grund af dets naturlige belysning. Dette kunne f.eks. være i animerede film. Dette viser dog også hvor langsom denne metoder alene er. Firmaer såsom _Disney_ og _Pixar_ har flere hundrede af grafikkort og det kan stadig tage flere timer at rendere.#footcite[#link("https://blogs.nvidia.com/blog/media2-rtx-pro-blackwell/")[NVIDIA Blackwell Powers Real-Time AI for Entertainment Workflows - NVIDIA Blog]]

== Perspektivering

Selvom denne opgave fokuserer på 3D-grafik, er det relevant at nævne lineær algebras bredere anvendelse. Netop fordi lineær algebra kan  beregnes effektivt på GPU'er, har den stor anvendelse.

_AI_ og _machine learning_ er nok det mest fremtrædende eksempel. _Neurale netværk_, som skal repræsenterer en digital hjerne, består fundamentalt af lag af søjlematricer, der sammen med matrixmultiplikationer efterfulgt af ikke-lineære aktiveringsfunktioner, kan modelerer komplekse problemmer. Det er de samme _tensor_ kerner i moderne grafikkort, der bruges til 3D-grafik i spil, som også bruges til at træne AI-modeller.

== Fremtiden

Da rasterisering er så effektivt, kommer der til at gå lang tid før det erstattes. Men da standarden for videospil grafikkort ikke bliver nedsat, kommer hybridløsninger som i Cyberpunk 2077, til at blive mere udbredt.

Neural network-baserede teknikker vinder også frem i videospil grafik. Den mest kendte løsning til dette, NVIDIA's DLSS, anvender machine learning til at opskallere billeder fra lavere opløsninger, hvilket reducerer beregningsbelastningen markant.

Afslutningsvis kan det konkluderes, at selvom grafikteknologi udvikler sig hurtigt, forbliver lineær algebra det stabile fundament, uanset om rasterisering skulle forsvinde en dag. De matricer og transformationer som er blevet præsenteret i denne opgave vil være lige så relevante om ti eller tyve år, selvom konteksten måske ændrer sig. Nye interfaces vil komme og gå, hardware vil blive kraftigere, og nye rendering-teknikker vil blive opfundet, men de matematiske principper, der blev formaliseret i fra den teoretiske del vil forblive det samme.

= Konklusion

I denne opgave er der blevet undersøgt, hvordan lineær algebra udgør det matematiske fundament for al moderne 3D-grafik i computerspil. Gennem vektorer og matricer muliggør lineær algebra rumlige transformationer og projektioner, som er afgørende for at kunne flytte, rotere, skalere og fremvise objekter fra en tredimensionel verden på en todimensionel skærm.

I den teoretiske gennemgang er der blevet redegjort for, hvordan lineære transformationer kan repræsenteres af matricer og sammensættes ved hjælp af matrixmultiplikation. Samt hvorfor homogene koordinater er nødvendige for at inkludere translation. 
Disse begreber er ikke blot abstrakte matematiske konstruktioner, som ligger over gymnasie-pensumet, men anvendes direkte i praksis i mange af de spil, der spilles i dag.

Analysen viser desuden, at lineær algebra er særligt velegnet til realtids 3D-grafik, på grund af dens evne til at blive beregneti parallelt på et grafikkort. Derudover blev alle de rumlige transformationer fra den teoretiske del vist i bevægelse ved hjælp af et eksempel program.

Der er blevet argumenteret både for og imod lineær algebras anvendelse i 3D-grafik. Rasterisering har klare begrænsninger, så snart at et højere grafik kvalitet bliver ønsket. Dette gælder især realistisk belysning som er en nødvendighed i moderne spil.

Samlet set kan det konkluderes, at selvom grafikteknologier og hardware udvikler sig hurtigt vil lineær algebra forblive uundværligt. Uanset om fremtidens computerspil benytter rasterisering, pathtracing eller andet, vil de grundlæggende matematiske principper fortsat spille en central rolle i udviklingen af interaktive 3D-verdener.

Kort om skrive processen: Opgaven er skrevet i markup sproget #link("https://typst.app/docs/")[_Typst_], som er en spirituel efterfølger til #LaTeX. Til forskel fra _Word_, som har et WYSIWYG (hvad du ser, er hvad du får) layout, bliver man nødt til selv at sammensætte det *hele* med kommandoer. Selvom det kan virke mere besværligt, har det mange fordele. Layoutet kommer altid til være fuldkommen forudsigeligt og separeres fra selve indholdet af ens dokument, derved bliver skrive processen mere overskuelig og lettere at håndtere. Desuden kan man gøre brug af typst's mange moduler og templates#footnote[På nuværende tidspunkt er der 485 moduler og 495 templates i #link("https://typst.app/universe/")[_Typst Universet_]] til at lave alt fra gantt-diagrammer, kvantekredsløb til figurer og modeller.

#pagebreak()

#bibliography(
  "kilder.yml"
)

#pagebreak()

= Bilag <bilag>

Det følgende er programkoden til eksempel applikationen.

```cpp
#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#include <iostream>
#include <vector>

const char *vertexShaderSource =
"#version 460 core\n"
"layout (location = 0) in vec3 inPos;"
"layout (location = 1) in vec3 inColor;"
""
"uniform mat4 model;"
"uniform mat4 projection;"
""
"out vec3 outColor;"
""
"void main()\n"
"{\n"
"   gl_Position = projection * model * vec4(inPos, 1.0f);"
"   outColor = inColor;"
"}\0";

const char *fragmentShaderSource =
"#version 460 core\n"
"out vec4 FragColor;\n"
"in vec3 outColor;\n"
"void main()\n"
"{\n"
"   FragColor = vec4(outColor, 1.0f);\n"
"}\0";

void framebuffer_size_callback(GLFWwindow* window, int width, int height)
{
    glViewport(0, 0, width, height);
}

#define CHECK_SHADER(shader, type) \
{ \
    int success; \
    char infoLog[512]; \
    glGetShaderiv(shader, GL_COMPILE_STATUS, &success); \
    if (!success) \
    { \
        glGetShaderInfoLog(shader, 512, NULL, infoLog); \
        std::cout << "ERROR::SHADER::" << type << "::COMPILATION_FAILED\n" << infoLog << std::endl; \
    } \
}

int SCREEN_WIDTH = 800;
int SCREEN_HEIGHT = 600;

int main() {
    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 4);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 6);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

    GLFWwindow* window = glfwCreateWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "SOP - Lineær Algebra", NULL, NULL);
    if (window == NULL)
    {
        std::cout << "Failed to create GLFW window" << std::endl;
        glfwTerminate();
        return -1;
    }
    glfwMakeContextCurrent(window);

    if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
    {
        std::cout << "Failed to initialize GLAD" << std::endl;
        return -1;
    }

    glViewport(0, 0, 800, 600);
    glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);  
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);

    float vertices[] = {
        -0.25f, -0.25f, 0.0f, 1.0f, 0.0f, 0.0f,
        0.25f, -0.25f, 0.0f, 0.0f, 1.0f, 0.0f,
        0.0f,  0.25f, 0.0f , 0.0f, 0.0f, 1.0f
    };

    unsigned int VAO;
    glGenVertexArrays(1, &VAO);
    glBindVertexArray(VAO);

    unsigned int VBO;
    glGenBuffers(1, &VBO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(0);

    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)(3 * sizeof(float)));
    glEnableVertexAttribArray(1);

    unsigned int vertexShader;
    vertexShader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertexShader, 1, &vertexShaderSource, NULL);
    glCompileShader(vertexShader);

    CHECK_SHADER(vertexShader, "VERTEX")

    unsigned int fragmentShader;
    fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShader, 1, &fragmentShaderSource, NULL);
    glCompileShader(fragmentShader);

    CHECK_SHADER(fragmentShader, "FRAGMENT")

    unsigned int shaderProgram;
    shaderProgram = glCreateProgram();
    glAttachShader(shaderProgram, vertexShader);
    glAttachShader(shaderProgram, fragmentShader);
    glLinkProgram(shaderProgram);

    CHECK_SHADER(shaderProgram, "PROGRAM")

    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);

    std::vector<glm::vec3> trianglePositions = {
        glm::vec3(-0.5f, 0.0f, 0.0f),
        glm::vec3(0.0f, 0.0f, 0.0f),
        glm::vec3(0.5f, 0.0f, 0.0f)
    };

    unsigned int modelLoc = glGetUniformLocation(shaderProgram, "model");
    unsigned int projectionLoc = glGetUniformLocation(shaderProgram, "projection");
    
    glm::mat4 perspective = glm::frustum(-1.0f, 1.0f, -1.0f, 1.0f, 1.0f, 10.0f);
    glm::mat4 orthographic = glm::ortho(-1.0f, 1.0f, -1.0f, 1.0f, 1.0f, 10.0f);

    while(!glfwWindowShouldClose(window))
    {
        glClear(GL_COLOR_BUFFER_BIT);
        
        glUseProgram(shaderProgram);
        glBindVertexArray(VAO);


        float time = (float)glfwGetTime();
        for (size_t i = 0; i < trianglePositions.size(); ++i) {
            
            glm::mat4 projection;
            switch (i) {
                case 0:
                    projection = perspective;
                    break;
                case 1:
                    projection = glm::identity<glm::mat4>();
                    break;
                case 2:
                    projection = orthographic;
                    break;
            }
            glUniformMatrix4fv(projectionLoc, 1, GL_FALSE, glm::value_ptr(projection));

            
            glm::mat4 transform = glm::identity<glm::mat4>();
            
            if (i == 0 || i == 2) {
                // oscellate along z-axis
                float zdistance = sin(time) * 2.0f - 3.0f; // Move between -5 and -3
                transform = glm::translate(transform, trianglePositions[i] + glm::vec3(0.0f, 0.0f, zdistance));
            } else {
                transform = glm::translate(transform, trianglePositions[i]);
                float angle = (time + (float)i) * glm::radians(60.0f);
                transform = glm::rotate(transform, angle, glm::vec3(0.0f, 0.0f, 1.0f));
                
                float scaleAmount = sin(time + i) * 0.5f + 1.0f;
                transform = glm::scale(transform, glm::vec3(scaleAmount, scaleAmount, scaleAmount));
            }
            glUniformMatrix4fv(modelLoc, 1, GL_FALSE, glm::value_ptr(transform));            
            
            glDrawArrays(GL_TRIANGLES, 0, 3);
        }

        glfwSwapBuffers(window);
        glfwPollEvents();    
    }

    glfwTerminate();

    return 0;
}
```
