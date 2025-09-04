//
//  Star.swift
//  DFVul1
//
//  Created by IGOR on 04/09/2025.
//

import SwiftUI
import Foundation

struct Star: Identifiable, Codable, Equatable {
    let id = UUID()
    var position: CGPoint
    var constellationType: ConstellationType
    var isMatched: Bool = false
    var isSelected: Bool = false
    var brightness: Double = 1.0
    
    enum ConstellationType: String, CaseIterable, Codable {
        case ursa = "Ursa Major"
        case orion = "Orion"
        case cassiopeia = "Cassiopeia"
        case draco = "Draco"
        case lyra = "Lyra"
        case cygnus = "Cygnus"
        case aquila = "Aquila"
        case perseus = "Perseus"
        case leo = "Leo"
        case virgo = "Virgo"
        case scorpius = "Scorpius"
        case sagittarius = "Sagittarius"
        case gemini = "Gemini"
        case cancer = "Cancer"
        case libra = "Libra"
        case aries = "Aries"
        case taurus = "Taurus"
        case capricornus = "Capricornus"
        case aquarius = "Aquarius"
        case pisces = "Pisces"
        
        var color: Color {
            switch self {
            case .ursa: return Color(hex: "#ffbe00")
            case .orion: return Color(hex: "#bd0e1b")
            case .cassiopeia: return Color(hex: "#ffffff")
            case .draco: return Color(hex: "#ffbe00")
            case .lyra: return Color(hex: "#bd0e1b")
            case .cygnus: return Color(hex: "#ffffff")
            case .aquila: return Color(hex: "#ffbe00")
            case .perseus: return Color(hex: "#bd0e1b")
            case .leo: return Color(hex: "#ffbe00")
            case .virgo: return Color(hex: "#ffffff")
            case .scorpius: return Color(hex: "#bd0e1b")
            case .sagittarius: return Color(hex: "#ffbe00")
            case .gemini: return Color(hex: "#ffffff")
            case .cancer: return Color(hex: "#bd0e1b")
            case .libra: return Color(hex: "#ffbe00")
            case .aries: return Color(hex: "#bd0e1b")
            case .taurus: return Color(hex: "#ffffff")
            case .capricornus: return Color(hex: "#ffbe00")
            case .aquarius: return Color(hex: "#bd0e1b")
            case .pisces: return Color(hex: "#ffffff")
            }
        }
        
        var pattern: [CGPoint] {
            switch self {
            case .ursa:
                return [
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: 30, y: -10),
                    CGPoint(x: 60, y: 0),
                    CGPoint(x: 90, y: -20),
                    CGPoint(x: 120, y: -10),
                    CGPoint(x: 150, y: 0),
                    CGPoint(x: 180, y: 10)
                ]
            case .orion:
                return [
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: 40, y: -30),
                    CGPoint(x: 80, y: -20),
                    CGPoint(x: 40, y: 20),
                    CGPoint(x: 80, y: 30),
                    CGPoint(x: 120, y: 40),
                    CGPoint(x: 160, y: 20)
                ]
            case .cassiopeia:
                return [
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: 40, y: -40),
                    CGPoint(x: 80, y: -20),
                    CGPoint(x: 120, y: -50),
                    CGPoint(x: 160, y: -30)
                ]
            case .draco:
                return [
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: 30, y: 20),
                    CGPoint(x: 60, y: 40),
                    CGPoint(x: 90, y: 30),
                    CGPoint(x: 120, y: 50),
                    CGPoint(x: 150, y: 40),
                    CGPoint(x: 180, y: 60),
                    CGPoint(x: 210, y: 50)
                ]
            case .lyra:
                return [
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: 40, y: -20),
                    CGPoint(x: 80, y: -40),
                    CGPoint(x: 120, y: -20),
                    CGPoint(x: 160, y: 0)
                ]
            case .cygnus:
                return [
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: 40, y: -30),
                    CGPoint(x: 80, y: -60),
                    CGPoint(x: 120, y: -30),
                    CGPoint(x: 160, y: 0),
                    CGPoint(x: 80, y: 30),
                    CGPoint(x: 80, y: 60)
                ]
            case .aquila:
                return [
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: 40, y: -20),
                    CGPoint(x: 80, y: -40),
                    CGPoint(x: 120, y: -60),
                    CGPoint(x: 160, y: -40),
                    CGPoint(x: 200, y: -20),
                    CGPoint(x: 240, y: 0)
                ]
            case .perseus:
                return [
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: 30, y: -30),
                    CGPoint(x: 60, y: -50),
                    CGPoint(x: 90, y: -30),
                    CGPoint(x: 120, y: -10),
                    CGPoint(x: 150, y: 10),
                    CGPoint(x: 180, y: 30)
                ]
            case .leo:
                return [
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: 40, y: -20),
                    CGPoint(x: 80, y: -30),
                    CGPoint(x: 120, y: -20),
                    CGPoint(x: 160, y: 0),
                    CGPoint(x: 200, y: 20),
                    CGPoint(x: 240, y: 40)
                ]
            case .virgo:
                return [
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: 30, y: -40),
                    CGPoint(x: 60, y: -60),
                    CGPoint(x: 90, y: -40),
                    CGPoint(x: 120, y: -20),
                    CGPoint(x: 150, y: 0),
                    CGPoint(x: 180, y: 20),
                    CGPoint(x: 210, y: 40)
                ]
            case .scorpius:
                return [
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: 30, y: 20),
                    CGPoint(x: 60, y: 30),
                    CGPoint(x: 90, y: 40),
                    CGPoint(x: 120, y: 50),
                    CGPoint(x: 150, y: 60),
                    CGPoint(x: 180, y: 70),
                    CGPoint(x: 210, y: 80)
                ]
            case .sagittarius:
                return [
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: 40, y: -30),
                    CGPoint(x: 80, y: -50),
                    CGPoint(x: 120, y: -30),
                    CGPoint(x: 160, y: -10),
                    CGPoint(x: 200, y: 10),
                    CGPoint(x: 240, y: 30)
                ]
            case .gemini:
                return [
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: 40, y: -20),
                    CGPoint(x: 80, y: -30),
                    CGPoint(x: 120, y: -20),
                    CGPoint(x: 160, y: 0),
                    CGPoint(x: 40, y: 40),
                    CGPoint(x: 80, y: 50),
                    CGPoint(x: 120, y: 40)
                ]
            case .cancer:
                return [
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: 40, y: -20),
                    CGPoint(x: 80, y: -10),
                    CGPoint(x: 120, y: -30),
                    CGPoint(x: 160, y: -20)
                ]
            case .libra:
                return [
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: 40, y: -30),
                    CGPoint(x: 80, y: -20),
                    CGPoint(x: 120, y: -40),
                    CGPoint(x: 160, y: -30),
                    CGPoint(x: 200, y: -10)
                ]
            case .aries:
                return [
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: 40, y: -30),
                    CGPoint(x: 80, y: -40),
                    CGPoint(x: 120, y: -30)
                ]
            case .taurus:
                return [
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: 40, y: -20),
                    CGPoint(x: 80, y: -30),
                    CGPoint(x: 120, y: -40),
                    CGPoint(x: 160, y: -30),
                    CGPoint(x: 200, y: -20),
                    CGPoint(x: 240, y: -10)
                ]
            case .capricornus:
                return [
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: 40, y: 20),
                    CGPoint(x: 80, y: 30),
                    CGPoint(x: 120, y: 20),
                    CGPoint(x: 160, y: 10),
                    CGPoint(x: 200, y: 0)
                ]
            case .aquarius:
                return [
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: 40, y: -20),
                    CGPoint(x: 80, y: -30),
                    CGPoint(x: 120, y: -20),
                    CGPoint(x: 160, y: -10),
                    CGPoint(x: 200, y: 0),
                    CGPoint(x: 240, y: 10)
                ]
            case .pisces:
                return [
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: 40, y: -30),
                    CGPoint(x: 80, y: -40),
                    CGPoint(x: 120, y: -30),
                    CGPoint(x: 160, y: -20),
                    CGPoint(x: 200, y: -10),
                    CGPoint(x: 240, y: 0),
                    CGPoint(x: 280, y: 10)
                ]
            }
        }
        
        var educationalTip: String {
            switch self {
            case .ursa:
                return "The Big Dipper is part of Ursa Major and points to the North Star. Tip: Regular stargazing can improve your sleep cycle!"
            case .orion:
                return "Orion is visible worldwide and contains the famous Orion Nebula. Tip: Night walks under stars can boost your mood!"
            case .cassiopeia:
                return "Cassiopeia looks like a 'W' in the sky and never sets in northern latitudes. Tip: Meditation under starlight enhances mindfulness!"
            case .draco:
                return "Draco wraps around the North Pole and was once home to the pole star. Tip: Deep breathing exercises work best in fresh night air!"
            case .lyra:
                return "Lyra contains Vega, one of the brightest stars in our sky. Tip: Listening to music outdoors can reduce stress!"
            case .cygnus:
                return "Cygnus flies along the Milky Way and contains the Northern Cross. Tip: Gentle stretching under stars improves flexibility!"
            case .aquila:
                return "Aquila soars near the celestial equator with bright Altair. Tip: Evening yoga sessions boost energy for the next day!"
            case .perseus:
                return "Perseus is home to the famous Perseid meteor shower. Tip: Wish-making and goal-setting improve mental wellness!"
            case .leo:
                return "Leo the Lion is a zodiac constellation with the bright star Regulus. Tip: Morning sun exposure helps regulate circadian rhythms!"
            case .virgo:
                return "Virgo is the largest zodiac constellation containing bright Spica. Tip: Organizing your space can improve mental clarity!"
            case .scorpius:
                return "Scorpius features the red giant Antares, rival of Mars. Tip: Evening relaxation routines enhance sleep quality!"
            case .sagittarius:
                return "Sagittarius points toward our galaxy's center and the Milky Way's heart. Tip: Setting goals aligns with natural cycles!"
            case .gemini:
                return "Gemini the Twins features bright stars Castor and Pollux. Tip: Social connections boost mental and physical health!"
            case .cancer:
                return "Cancer contains the beautiful Beehive Cluster of stars. Tip: Gentle exercise like walking improves overall wellness!"
            case .libra:
                return "Libra the Scales represents balance and harmony in the sky. Tip: Work-life balance is key to sustainable health!"
            case .aries:
                return "Aries the Ram marks the beginning of spring in the northern hemisphere. Tip: Fresh starts boost motivation and energy!"
            case .taurus:
                return "Taurus features the Pleiades star cluster and bright Aldebaran. Tip: Patience and persistence lead to lasting wellness!"
            case .capricornus:
                return "Capricornus is an ancient constellation representing the sea-goat. Tip: Consistent routines build healthy habits!"
            case .aquarius:
                return "Aquarius the Water Bearer is associated with innovation and progress. Tip: Staying hydrated improves cognitive function!"
            case .pisces:
                return "Pisces the Fishes completes the zodiac circle in the sky. Tip: Swimming and water activities reduce stress naturally!"
            }
        }
        
        var detailedDescription: String {
            switch self {
            case .ursa:
                return "Ursa Major, the Great Bear, is one of the most recognizable constellations in the northern sky. The Big Dipper asterism forms the bear's hindquarters and tail. Ancient cultures worldwide have stories about this constellation, from the Native American Great Bear to the Hindu Seven Sages."
            case .orion:
                return "Orion the Hunter is perhaps the most famous constellation, visible from both hemispheres. The three stars of Orion's Belt - Alnitak, Alnilam, and Mintaka - are among the most recognizable star patterns. The Orion Nebula, visible to the naked eye, is a stellar nursery where new stars are born."
            case .cassiopeia:
                return "Cassiopeia the Queen sits opposite the Big Dipper across the North Star. This distinctive W-shaped constellation never sets for observers in northern latitudes. In Greek mythology, Cassiopeia was the vain queen of Ethiopia who boasted about her beauty."
            case .draco:
                return "Draco the Dragon winds between the Big and Little Dippers. Around 3000 BCE, the star Thuban in Draco was the pole star, used by ancient Egyptians to align their pyramids. This constellation represents Ladon, the dragon that guarded the golden apples in Greek mythology."
            case .lyra:
                return "Lyra the Harp is a small but prominent constellation containing Vega, the fifth-brightest star in our sky. Vega was the northern pole star around 12,000 BCE and will be again around 13,727 CE. In mythology, this is the lyre of Orpheus, whose music could charm all living things."
            case .cygnus:
                return "Cygnus the Swan flies along the Milky Way, also known as the Northern Cross. The star Deneb marks the swan's tail and is one of the most distant stars visible to the naked eye at about 2,600 light-years away. This constellation represents Zeus in disguise as a swan."
            case .aquila:
                return "Aquila the Eagle soars near the celestial equator. Its brightest star, Altair, forms part of the Summer Triangle with Vega and Deneb. In mythology, Aquila carried Zeus's thunderbolts and was sent to carry Ganymede to Olympus to serve as cupbearer to the gods."
            case .perseus:
                return "Perseus the Hero is famous for the annual Perseid meteor shower that appears to radiate from this constellation in August. Perseus represents the Greek hero who slayed Medusa and rescued Andromeda. The star Algol represents Medusa's winking eye."
            case .leo:
                return "Leo the Lion is a zodiac constellation best seen in spring. Its brightest star, Regulus, marks the lion's heart and was known as the 'Royal Star' to ancient Persians. This constellation represents the Nemean Lion killed by Hercules in his first labor."
            case .virgo:
                return "Virgo the Maiden is the largest zodiac constellation and second-largest overall. Its brightest star, Spica, is actually a binary star system. Virgo represents various harvest goddesses including Demeter, Ceres, and Isis, holding wheat sheaves that Spica represents."
            case .scorpius:
                return "Scorpius the Scorpion is a zodiac constellation that actually resembles its namesake. The red giant star Antares marks the scorpion's heart and rivals Mars in color and brightness. In mythology, this scorpion was sent to kill the hunter Orion."
            case .sagittarius:
                return "Sagittarius the Archer points toward the center of our Milky Way galaxy. This constellation contains the densest concentration of stars visible from Earth. It represents a centaur archer, often identified with Chiron, the wise centaur who taught heroes."
            case .gemini:
                return "Gemini the Twins features the bright stars Castor and Pollux, named after the mythological twins. These stars mark the heads of the twins in the constellation. In Greek mythology, they were the sons of Leda but had different fathers - one mortal, one divine."
            case .cancer:
                return "Cancer the Crab is the faintest zodiac constellation but contains the beautiful Beehive Cluster (M44). This open star cluster contains over 1,000 stars and is visible to the naked eye as a fuzzy patch. Cancer represents the crab that pinched Hercules during his battle with the Hydra."
            case .libra:
                return "Libra the Scales is the only zodiac constellation representing an inanimate object. Originally, these stars were considered part of Scorpius, representing the scorpion's claws. The Romans made it a separate constellation to represent justice and balance."
            case .aries:
                return "Aries the Ram is the first zodiac constellation, marking the vernal equinox in ancient times. Though small and relatively faint, it represents the golden-fleeced ram from the story of Jason and the Argonauts. The ram's fleece became the Golden Fleece."
            case .taurus:
                return "Taurus the Bull contains two famous star clusters: the Pleiades (Seven Sisters) and the Hyades. The bright red giant Aldebaran appears to be part of the Hyades but is actually much closer to us. This constellation represents Zeus disguised as a bull."
            case .capricornus:
                return "Capricornus the Sea-Goat is one of the faintest zodiac constellations. It represents a creature with a goat's head and a fish's tail. In Babylonian mythology, this was Ea, the god of water and wisdom who warned humanity of the great flood."
            case .aquarius:
                return "Aquarius the Water Bearer is a large but faint constellation. It contains the closest planetary nebula to Earth, the Helix Nebula, often called the 'Eye of God.' This constellation represents Ganymede, the cupbearer of the gods, pouring water from an urn."
            case .pisces:
                return "Pisces the Fishes represents two fish tied together by their tails. This large but faint constellation contains the vernal equinox point in modern times. In mythology, these are Aphrodite and Eros who transformed into fish to escape the monster Typhon."
            }
        }
        
        var bestViewingTime: String {
            switch self {
            case .ursa: return "Visible year-round in northern latitudes, best in spring"
            case .orion: return "Best viewed in winter evenings (December-February)"
            case .cassiopeia: return "Visible year-round in northern latitudes, best in autumn"
            case .draco: return "Best viewed in summer evenings (June-August)"
            case .lyra: return "Best viewed in summer and early autumn (July-September)"
            case .cygnus: return "Best viewed in summer and autumn (August-October)"
            case .aquila: return "Best viewed in summer evenings (July-September)"
            case .perseus: return "Best viewed in autumn and winter (October-January)"
            case .leo: return "Best viewed in spring evenings (March-May)"
            case .virgo: return "Best viewed in spring and early summer (April-June)"
            case .scorpius: return "Best viewed in summer evenings (June-August)"
            case .sagittarius: return "Best viewed in summer evenings (July-September)"
            case .gemini: return "Best viewed in winter evenings (December-February)"
            case .cancer: return "Best viewed in winter and spring (February-April)"
            case .libra: return "Best viewed in summer evenings (June-August)"
            case .aries: return "Best viewed in autumn evenings (October-December)"
            case .taurus: return "Best viewed in winter evenings (November-January)"
            case .capricornus: return "Best viewed in late summer (August-September)"
            case .aquarius: return "Best viewed in autumn evenings (September-November)"
            case .pisces: return "Best viewed in autumn evenings (October-December)"
            }
        }
        
        var difficulty: Int {
            switch self {
            case .ursa, .orion, .cassiopeia: return 1 // Easy - very recognizable
            case .leo, .cygnus, .scorpius, .taurus: return 2 // Medium - clear patterns
            case .lyra, .aquila, .perseus, .gemini, .sagittarius: return 3 // Medium-Hard
            case .draco, .virgo, .cancer, .libra, .aries, .capricornus, .aquarius, .pisces: return 4 // Hard - faint or complex
            }
        }
    }
}

struct Constellation {
    let type: Star.ConstellationType
    let stars: [Star]
    let isComplete: Bool
    
    init(type: Star.ConstellationType, centerPosition: CGPoint) {
        self.type = type
        self.isComplete = false
        self.stars = type.pattern.map { offset in
            Star(
                position: CGPoint(
                    x: centerPosition.x + offset.x,
                    y: centerPosition.y + offset.y
                ),
                constellationType: type
            )
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
