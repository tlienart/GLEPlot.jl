"""
    add_dict_vals!(d)

Internal function to add the values of a dictionary as keys with the same
values. So for instance if the dictionary has a pair "s" => "square", it
will add "square" => "square".
"""
function add_dict_vals!(d::LittleDict{String,String})
    for v ∈ values(d)
        get(d, v) do
            d[v] = v
        end
    end
    return
end


const GLE_MARKERS = LittleDict{String,String}(
    "^"  => "triangle"   ,
    "w^" => "wtriangle"  ,
    "f^" => "ftriangle"  ,
    "s"  => "square"     ,
    "ws" => "wsquare"    ,
    "fs" => "fsquare"    ,
    "o"  => "circle"     ,
    "wo" => "wcircle"    ,
    "."  => "fcircle"    ,
    "fo" => "fcircle"    ,
    "d"  => "diamond"    ,
    "wd" => "wdiamond"   ,
    "fd" => "fdiamond"   ,
    "x"  => "cross"      ,
    "+"  => "plus"       ,
    "-"  => "minus"      ,
    "*"  => "asterisk"   ,
    "o." => "odot"       ,
    "o-" => "ominus"     ,
    "o+" => "oplus"      ,
    "ox" => "otimes"     ,
    "clubs"   => "club"  ,
    "hearts"  => "heart" ,
    "spades"  => "spade" ,
    "dagger"  => "dag"   ,
    "ddagger" => "ddag"  ,
    # ones without direct abbreviation / alias
    "star"    => "star"  ,
    "star2"   => "star2" ,
    "star3"   => "star3" ,
    "star4"   => "star4" ,
    "flower"  => "flower",
    "snake"   => "snake" ,
    "none"    => "none"  ,
    )
add_dict_vals!(GLE_MARKERS)


const GLE_LSTYLES = LittleDict{String,Int}(
    "-"    => 0,
    "--"   => 9,
    "-."   => 8,
    "none" => -1,
    )


const GLE_TEXSCALE = ("scale", "fixed", "none")


const GLE_FONTS = LittleDict{String,String}(
    "roman"                 => "rm"     ,
    "roman-bold"            => "rmb"    ,
    "roman-italic"          => "rmi"    ,
    "sans-serif"            => "ss"     ,
    "sans-serif-bold"       => "ssb"    ,
    "sans-serif-italic"     => "ssi"    ,
    "typewriter"            => "tt"     ,
    "typewriter-bold"       => "ttb"    ,
    "typewriter-italic"     => "tti"    ,
    "times"                 => "pstr"   ,
    "times-roman"           => "pstr"   ,
    "times-bold"            => "pstb"   ,
    "times-italic"          => "psti"   ,
    "times-bold-italic"     => "pstbi"  ,
    "courier"               => "psc"    ,
    "courier-bold"          => "pscb"   ,
    "courier-oblique"       => "psco"   ,
    "courier-bold-oblique"  => "pscbo"  ,
    "helvetica"                     => "psh"    ,
    "helvetica-bold"                => "pshb"   ,
    "helvetica-oblique"             => "psho"   ,
    "helvetica-bold-oblique"        => "pshbo"  ,
    "helvetica-narrow"              => "pshn"   ,
    "helvetica-narrow-bold"         => "pshnb"  ,
    "helvetica-narrow-oblique"      => "pshno"  ,
    "helvetica-narrow-bold-oblique" => "pshnbo" ,
    "avantgarde"                    => "psagb"  ,
    "avantgarde-book"               => "psagb"  ,
    "avantgarde-demi"               => "psagd"  ,
    "avantgarde-book-oblique"       => "psagbo" ,
    "avantgarde-demi-oblique"       => "psagdo" ,
    "bookman"               => "psbl"   ,
    "bookman-light"         => "psbl"   ,
    "bookman-demi"          => "psbd"   ,
    "bookman-light-italic"  => "psbli"  ,
    "bookman-demi-italic"   => "psbdi"  ,
    "newcentury"            => "psncsr" ,
    "newcentury-roman"      => "psncsr" ,
    "newcentury-bold"       => "psncsb" ,
    "newcentury-italic"     => "psncsi" ,
    "newcentury-bold-italic"=> "psncsbi",
    "palatino"              => "pspr"   ,
    "palatino-roman"        => "pspr"   ,
    "palantino-bold"        => "pspb"   ,
    "palatino-italic"       => "pspi"   ,
    "palatino-bold-italic"  => "pspbi"  ,
    "cmr"   => "texcmr"   ,
    "cmb"   => "texcmb"   ,
    "cmti"  => "texcmti"  ,
    "cmmi"  => "texcmmi"  ,
    "cmss"  => "texcmss"  ,
    "cmssb" => "texcmssb" ,
    "cmssi" => "texcmssi" ,
    "cmtt"  => "texcmtt"  ,
    "cmitt" => "texcmitt" ,
    "computer-modern-roman"             => "texcmr"  ,
    "computer-modern-bold"              => "texcmb"  ,
    "computer-modern-text-italic"       => "texcmti" ,
    "computer-modern-maths-italic"      => "texcmmi" ,
    "computer-modern-sans-serif"        => "texcmss" ,
    "computer-modern-sans-serif-bold"   => "texcmssb",
    "computer-modern-sans-serif-italic" => "texcmssi",
    "computer-modern-typewriter"        => "texcmtt" ,
    "computer-modern-italic-typewriter" => "texcmitt",
    # fonts with no description (yet)
    "plsr"   => "plsr",
    "pldr"   => "pldr",
    "pltr"   => "pltr",
    "plti"   => "plti",
    "plcr"   => "plcr",
    "plci"   => "plci",
    "plss"   => "plss",
    "plcs"   => "plcs",
    "plsa"   => "plsa",
    "plba"   => "plba",
    "plge"   => "plge",
    "plgg"   => "plgg",
    "plgi"   => "plgi",
    "plsg"   => "plsg",
    "pshc"   => "pshc",
    "pshcb"  => "pshcb",
    "pshcdo" => "pshcdo",
    "pssym"  => "pssym",
    "zapfchancery-medium-italic" => "pszd",
    "arial" => "arial8",
    "arial-bold" => "arial8b",
    "arial-bold-italic" => "arial8bi",
    "arial-italic" => "arial8i",
    "plcc" => "plcc",
    "plcg" => "plcg",
    "pscb" => "pscb",
    "pshcbo" => "pshcbo",
    "pszcmi" => "pszcmi",
    "texcmex" => "texcmex",
    "texcmsy" => "texcmsy",
    "texex" => "texex",
    "texmi" => "texmi",
    "texsy" => "texsy",
    "times" => "times8",
    "times-bold" => "times8b",
    "typerwiter-bold-italic" => "ttbi",
    )
add_dict_vals!(GLE_FONTS)


const GLE_POSITION = LittleDict{String,String}(
    "top-left"      => "tl",
    "bottom-left"   => "bl",
    "top-right"     => "tr",
    "bottom-right"  => "br",
    "top-center"    => "tc",
    "bottom-center" => "bc",
    "left-center"   => "lc",
    "right-center"  => "rc",
    "center"        => "cc",
    )
add_dict_vals!(GLE_POSITION)


const HIST2D_SCALING = LittleDict{String,String}(
    "none"  => "count",
    "pdf"   => "pdf",
    "prob"  => "probability",
    )
add_dict_vals!(HIST2D_SCALING)


const AXSCALE = LittleDict{String,Bool}(
    "log"         => true,
    "logarithmic" => true,
    "lin"         => false,
    "linear"      => false,
    )
