'tRumors

function get_rumor(i as short=18) as string
    dim as short last=18
    if i=0 then i=last
    select case i
    case 1 'Station Commander
        return ""
    case 2 'Freelancer
        select case rnd_range(1,6)
        case 1
            return "I heard nobody has ever returned from exploring a system at coordinates "&cords(map(sysfrommap(specialplanet(2))).c) &"."
        case 2
            return "There are planets out there where the ice will come after you and kill you! I call them Icetrolls, they freeze during the night, and thaw during the day. Keep in the dark when you are on such a planet."
        case 3
        end select

    case 3 'Security
        return "My tribble helped me cope when a friend of mine was killed by wildlife on some backwater planet"

    case 4 'Science
    case 5 'Gunner
    case 6 'Doctor
    case 7 'Merchant
    case 8 'colonist
    case 9 'Tourist
    case 10 'EE
    case 11 'SHI
    case 12 'TT
    case 13 'OBE
    case 14 'Entertainer
    case 15 'Xenobio
    case 16 'Astro
    case 17 'Engineer
    case 18 'General bar rumor
        return "I heard the leader of the pirates is choosen in a spaceship duel."
    end select
end function

