return {
   random_event = {
      skip = function(_1)
         return ("「%s」")
            :format(_1)
      end,
      title = function(_1)
         return ("《 %s 》")
            :format(_1)
      end,
      _ = {
         elona = {
            _1 = {
               choices = {
                  _0 = "よし"
               },
               text = "あなたは一瞬嫌な予感がしたが、それはやがて消えた。",
               title = "不運の回避"
            },
            _10 = {
               choices = {
                  _0 = "調べる",
                  _1 = "立ち去る"
               },
               text = "あなたは何者かが野営した跡を見つけた。辺りには食べ残しやがらくたが散らばっている。もしかしたら、何か役に立つものがあるかもしれない。",
               title = "野営跡の発見"
            },
            _11 = {
               bury = "あなたは骨と遺留品を埋葬した。",
               choices = {
                  _0 = "あさる",
                  _1 = "埋葬する"
               },
               loot = "あなたは遺留品をあさった。",
               text = "この場所で力尽きた冒険者の遺骸を見つけた。既に朽ちかけている骨と、身に着けていたと思われる幾つかの装備が散らばっている。",
               title = "冒険者の遺骸"
            },
            _12 = {
               choices = {
                  _0 = "よし"
               },
               text = "石ころにつまずいて転んだ拍子に、あなたは幾つかのマテリアルを見つけた。",
               title = "マテリアルの発見"
            },
            _13 = {
               choices = {
                  _0 = "腹減った…"
               },
               text = "どこからともなく漂うご馳走の匂いで、あなたの胃は不満を叫び始めた。",
               title = "ご馳走の匂い"
            },
            _14 = {
               choices = {
                  _0 = "食べる",
                  _1 = "立ち去る"
               },
               text = "あなたは目の前にご馳走をみつけた。",
               title = "謎のご馳走"
            },
            murderer = {
               choices = {
                  _0 = "なむ…"
               },
               scream = function(_1)
                  return ("%s「ぎゃぁーー！」")
                     :format(name(_1))
               end,
               text = "街のどこかで悲鳴があがった。あなたはガードが慌しく走っていくのを目撃した。「人殺し、人殺しだ！！」",
               title = "殺人鬼"
            },
            _16 = {
               choices = {
                  _0 = "ラッキー！"
               },
               text = "発狂した金持ちが、何か叫びながら金貨をばらまいている…",
               title = "発狂した金持ち",
               you_pick_up = function(_1)
                  return ("金貨%s枚を手に入れた。")
                     :format(_1)
               end
            },
            _17 = {
               choices = {
                  _0 = "ありがとう"
               },
               text = "突然、向かいからやって来た一人の神官が、すれ違いざまにあなたに魔法をかけた。「ノープロブレム」",
               title = "辻プリースト"
            },
            _18 = {
               choices = {
                  _0 = "神よ"
               },
               text = "夢の中で、あなたは偉大なる者の穏やかな威光に触れた。",
               title = "信仰の深まり"
            },
            _19 = {
               choices = {
                  _0 = "ワァオー"
               },
               text = "あなたは夢の中で宝を埋めた。あなたはすぐに飛び起き、その場所を紙に書き留めた",
               title = "宝を埋める夢"
            },
            _2 = {
               choices = {
                  _0 = "おかしな夢だ"
               },
               text = "夢の中であなたは赤い髪の魔術師に出会った。「誰じゃ、お主は？ふむ、間違った者の夢に現れてしまったようじゃ。すまぬな。お詫びといってはなんじゃが…」魔法使いは指をくるりと回した。あなたは軽い頭痛を覚えた。",
               title = "魔法使いの夢"
            },
            _20 = {
               choices = {
                  _0 = "ワァオー"
               },
               text = "うみみゃぁ！",
               title = "幸運の日"
            },
            _21 = {
               choices = {
                  _0 = "ワァオー"
               },
               text = "うみみゃっ、見つけたね！",
               title = "運命の気まぐれ"
            },
            _22 = {
               choices = {
                  _0 = "ううぅん…"
               },
               text = "あなたは怪物と戦っていた。醜い化け物に斬りかかろうとした時、怪物は悲鳴をあげた。「オレハオマエダ！オマエハオレダ！」あなたは自分の呻き声に起こされた。",
               title = "怪物の夢"
            },
            _23 = {
               choices = {
                  _0 = "るん♪"
               },
               text = "夢の中で、あなたはのんきにマテリアルを採取していた",
               title = "夢の中の収穫"
            },
            _24 = {
               choices = {
                  _0 = "ワァオー"
               },
               text = "突然あなたの才能は開花した！",
               title = "才能の開花"
            },
            _3 = {
               choices = {
                  _0 = "よし！"
               },
               text = "長年の鍛錬の成果が実ったようだ。なかなか眠りにつけず考えごとをしていたあなたは、ふと、自らの技術に関する新しいアイデアを思いついた。",
               title = "成長のきざし"
            },
            _4 = {
               choices = {
                  _0 = "おかしな夢だ"
               },
               text = "あなたは不気味な夢をみた。陰気な幾つもの瞳があなたを凝視し、どこからともなく笑い声がこだました。「ケラケラケラ…ミツケタヨ…ケラケラ」あなたが二度寝返りをうった後、その夢は終わった。",
               title = "不気味な夢"
            },
            _5 = {
               choices = {
                  _0 = "眠れない…"
               },
               no_effect = "あなたは祈祷を捧げ呪いのつぶやきを無効にした。",
               text = "どこからともなく聞こえる呪いのつぶやきが、あなたの眠りを妨げた。",
               title = "呪いのつぶやき"
            },
            _6 = {
               choices = {
                  _0 = "よし"
               },
               text = "身体が妙に火照ってあなたは目を覚ました。気がつくと、腕にあった傷跡が完全に消えていた。",
               title = "自然治癒力の向上"
            },
            _7 = {
               choices = {
                  _0 = "よし"
               },
               text = "あなたは、夢の中でも驚くほど理性を保っていた。まるで瞑想を行っている時のように、あなたは心の平和を感じた。",
               title = "瞑想力の向上"
            },
            _8 = {
               choices = {
                  _0 = "盗人め…"
               },
               no_effect = "損害はなかった。",
               text = "悪意のある手が忍び寄り、あなたが気付かない間に金貨を奪って逃げた。",
               title = "悪意ある手",
               you_lose = function(_1)
                  return ("金貨%s枚を失った。")
                     :format(_1)
               end
            },
            _9 = {
               choices = {
                  _0 = "ラッキー！"
               },
               text = "下を向いて歩いていると、幸運にもプラチナ硬貨を見つけた。",
               title = "路上に転がる幸運"
            },
            marriage = {
               choices = {
                  _0 = "生涯をあなたに捧げる"
               },
               text = function(_1)
                  return ("長い交際の末、遂にあなたと%sは固い絆で結ばれた。婚儀の後、あなたの元に幾つか祝儀品が届けられた。")
                     :format(name(_1))
               end,
               title = "結婚"
            },
            reunion_with_pet = {
               choices = {
                  _0 = "犬だ！",
                  _1 = "猫だ！",
                  _2 = "クマだ！",
                  _3 = "少女だ！"
               },
               text = "あなたは懐かしい鳴き声に気付いて、ふと歩みを止めた。なんと、船が難破した時に居なくなったあなたのペットが、嬉しそうに走ってくる！あなたのペットは…",
               title = "ペットとの再会"
            },
         },
      }
   }
}
