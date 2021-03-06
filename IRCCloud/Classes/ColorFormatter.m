//
//  ColorFormatter.m
//
//  Copyright (C) 2013 IRCCloud, Ltd.
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.


#import "ColorFormatter.h"
#import "LinkTextView.h"
#import "UIColor+IRCCloud.h"
#import "NSURL+IDN.h"
#import "NetworkConnection.h"

id Courier = NULL, CourierBold, CourierOblique,CourierBoldOblique;
id Helvetica, HelveticaBold, HelveticaOblique,HelveticaBoldOblique;
id arrowFont, chalkboardFont, markerFont, awesomeFont;
UIFont *timestampFont, *monoTimestampFont;
NSDictionary *emojiMap;
NSDictionary *quotes;
float ColorFormatterCachedFontSize = 0.0f;

@implementation ColorFormatter

+(BOOL)shouldClearFontCache {
    return ColorFormatterCachedFontSize != FONT_SIZE;
}

+(void)clearFontCache {
    CLS_LOG(@"Clearing font cache");
    Courier = CourierBold = CourierBoldOblique = CourierOblique = Helvetica = HelveticaBold = HelveticaBoldOblique = HelveticaOblique = arrowFont = chalkboardFont = markerFont = NULL;
    timestampFont = monoTimestampFont = awesomeFont = NULL;
}

+(UIFont *)timestampFont {
    if(!timestampFont) {
        timestampFont = [UIFont systemFontOfSize:FONT_SIZE - 2];
    }
    return timestampFont;
}

+(UIFont *)monoTimestampFont {
    if(!monoTimestampFont) {
        monoTimestampFont = [UIFont fontWithName:@"Courier" size:FONT_SIZE - 2];
    }
    return monoTimestampFont;
}

+(UIFont *)awesomeFont {
    if(!awesomeFont) {
        awesomeFont = [UIFont fontWithName:@"FontAwesome" size:FONT_SIZE];
    }
    return awesomeFont;
}

+(UIFont *)messageFont:(BOOL)mono {
    return mono?Courier:Helvetica;
}

+(NSRegularExpression *)emoji {
    if(!emojiMap)
        emojiMap = @{
                     @"poodle":@"🐩",
                     @"black_joker":@"🃏",
                     @"dog2":@"🐕",
                     @"hotel":@"🏨",
                     @"fuelpump":@"⛽",
                     @"mouse2":@"🐁",
                     @"nine":@"9⃣",
                     @"basketball":@"🏀",
                     @"earth_asia":@"🌏",
                     @"heart_eyes":@"😍",
                     @"arrow_heading_down":@"⤵️",
                     @"fearful":@"😨",
                     @"o":@"⭕️",
                     @"waning_gibbous_moon":@"🌖",
                     @"pensive":@"😔",
                     @"mahjong":@"🀄",
                     @"closed_umbrella":@"🌂",
                     @"grinning":@"😀",
                     @"mag_right":@"🔎",
                     @"round_pushpin":@"📍",
                     @"nut_and_bolt":@"🔩",
                     @"no_bell":@"🔕",
                     @"incoming_envelope":@"📨",
                     @"repeat":@"🔁",
                     @"notebook_with_decorative_cover":@"📔",
                     @"arrow_forward":@"▶️",
                     @"dvd":@"📀",
                     @"ram":@"🐏",
                     @"cloud":@"☁️",
                     @"curly_loop":@"➰",
                     @"trumpet":@"🎺",
                     @"love_hotel":@"🏩",
                     @"pig2":@"🐖",
                     @"fast_forward":@"⏩",
                     @"ox":@"🐂",
                     @"checkered_flag":@"🏁",
                     @"sunglasses":@"😎",
                     @"weary":@"😩",
                     @"heavy_multiplication_x":@"✖️",
                     @"last_quarter_moon":@"🌗",
                     @"confused":@"😕",
                     @"night_with_stars":@"🌃",
                     @"grin":@"😁",
                     @"lock_with_ink_pen":@"🔏",
                     @"paperclip":@"📎",
                     @"black_large_square":@"⬛️",
                     @"seat":@"💺",
                     @"envelope_with_arrow":@"📩",
                     @"bookmark":@"🔖",
                     @"closed_book":@"📕",
                     @"repeat_one":@"🔂",
                     @"file_folder":@"📁",
                     @"violin":@"🎻",
                     @"boar":@"🐗",
                     @"water_buffalo":@"🐃",
                     @"snowboarder":@"🏂",
                     @"smirk":@"😏",
                     @"bath":@"🛀",
                     @"scissors":@"✂️",
                     @"waning_crescent_moon":@"🌘",
                     @"confounded":@"😖",
                     @"sunrise_over_mountains":@"🌄",
                     @"joy":@"😂",
                     @"straight_ruler":@"📏",
                     @"computer":@"💻",
                     @"link":@"🔗",
                     @"arrows_clockwise":@"🔃",
                     @"book":@"📖",
                     @"open_book":@"📖",
                     @"snowflake":@"❄️",
                     @"open_file_folder":@"📂",
                     @"left_right_arrow":@"↔",
                     @"musical_score":@"🎼",
                     @"elephant":@"🐘",
                     @"cow2":@"🐄",
                     @"womens":@"🚺",
                     @"runner":@"🏃",
                     @"running":@"🏃",
                     @"bathtub":@"🛁",
                     @"crescent_moon":@"🌙",
                     @"arrow_up_down":@"↕",
                     @"sunrise":@"🌅",
                     @"smiley":@"😃",
                     @"kissing":@"😗",
                     @"black_medium_small_square":@"◾️",
                     @"briefcase":@"💼",
                     @"radio_button":@"🔘",
                     @"arrows_counterclockwise":@"🔄",
                     @"green_book":@"📗",
                     @"black_small_square":@"▪️",
                     @"page_with_curl":@"📃",
                     @"arrow_upper_left":@"↖",
                     @"running_shirt_with_sash":@"🎽",
                     @"octopus":@"🐙",
                     @"tiger2":@"🐅",
                     @"restroom":@"🚻",
                     @"surfer":@"🏄",
                     @"passport_control":@"🛂",
                     @"slot_machine":@"🎰",
                     @"phone":@"☎",
                     @"telephone":@"☎",
                     @"kissing_heart":@"😘",
                     @"city_sunset":@"🌆",
                     @"arrow_upper_right":@"↗",
                     @"smile":@"😄",
                     @"minidisc":@"💽",
                     @"back":@"🔙",
                     @"low_brightness":@"🔅",
                     @"blue_book":@"📘",
                     @"page_facing_up":@"📄",
                     @"moneybag":@"💰",
                     @"arrow_lower_right":@"↘",
                     @"tennis":@"🎾",
                     @"baby_symbol":@"🚼",
                     @"circus_tent":@"🎪",
                     @"leopard":@"🐆",
                     @"black_circle":@"⚫️",
                     @"customs":@"🛃",
                     @"8ball":@"🎱",
                     @"kissing_smiling_eyes":@"😙",
                     @"city_sunrise":@"🌇",
                     @"heavy_plus_sign":@"➕",
                     @"arrow_lower_left":@"↙",
                     @"sweat_smile":@"😅",
                     @"ballot_box_with_check":@"☑",
                     @"floppy_disk":@"💾",
                     @"high_brightness":@"🔆",
                     @"muscle":@"💪",
                     @"orange_book":@"📙",
                     @"date":@"📅",
                     @"currency_exchange":@"💱",
                     @"heavy_minus_sign":@"➖",
                     @"ski":@"🎿",
                     @"toilet":@"🚽",
                     @"ticket":@"🎫",
                     @"rabbit2":@"🐇",
                     @"umbrella":@"☔️",
                     @"trophy":@"🏆",
                     @"baggage_claim":@"🛄",
                     @"game_die":@"🎲",
                     @"potable_water":@"🚰",
                     @"rainbow":@"🌈",
                     @"laughing":@"😆",
                     @"satisfied":@"😆",
                     @"heavy_division_sign":@"➗",
                     @"cd":@"💿",
                     @"mute":@"🔇",
                     @"dizzy":@"💫",
                     @"calendar":@"📆",
                     @"heavy_dollar_sign":@"💲",
                     @"wc":@"🚾",
                     @"clapper":@"🎬",
                     @"umbrella":@"☔",
                     @"cat2":@"🐈",
                     @"horse_racing":@"🏇",
                     @"door":@"🚪",
                     @"bowling":@"🎳",
                     @"non-potable_water":@"🚱",
                     @"left_luggage":@"🛅",
                     @"bridge_at_night":@"🌉",
                     @"innocent":@"😇",
                     @"coffee":@"☕",
                     @"white_large_square":@"⬜️",
                     @"speaker":@"🔈",
                     @"speech_balloon":@"💬",
                     @"card_index":@"📇",
                     @"credit_card":@"💳",
                     @"wavy_dash":@"〰",
                     @"shower":@"🚿",
                     @"performing_arts":@"🎭",
                     @"dragon":@"🐉",
                     @"no_entry_sign":@"🚫",
                     @"football":@"🏈",
                     @"flower_playing_cards":@"🎴",
                     @"bike":@"🚲",
                     @"carousel_horse":@"🎠",
                     @"smiling_imp":@"😈",
                     @"parking":@"🅿️",
                     @"sound":@"🔉",
                     @"thought_balloon":@"💭",
                     @"sparkle":@"❇️",
                     @"chart_with_upwards_trend":@"📈",
                     @"yen":@"💴",
                     @"diamond_shape_with_a_dot_inside":@"💠",
                     @"video_game":@"🎮",
                     @"smoking":@"🚬",
                     @"rugby_football":@"🏉",
                     @"musical_note":@"🎵",
                     @"no_bicycles":@"🚳",
                     @"ferris_wheel":@"🎡",
                     @"wink":@"😉",
                     @"vs":@"🆚",
                     @"eight_spoked_asterisk":@"✳️",
                     @"gemini":@"♊️",
                     @"gemini":@"♊",
                     @"white_flower":@"💮",
                     @"white_small_square":@"▫️",
                     @"chart_with_downwards_trend":@"📉",
                     @"spades":@"♠️",
                     @"dollar":@"💵",
                     @"five":@"5️⃣",
                     @"bulb":@"💡",
                     @"dart":@"🎯",
                     @"no_smoking":@"🚭",
                     @"zero":@"0⃣",
                     @"notes":@"🎶",
                     @"cancer":@"♋",
                     @"roller_coaster":@"🎢",
                     @"mountain_cableway":@"🚠",
                     @"bicyclist":@"🚴",
                     @"no_entry":@"⛔️",
                     @"seven":@"7️⃣",
                     @"leftwards_arrow_with_hook":@"↩️",
                     @"100":@"💯",
                     @"leo":@"♌",
                     @"arrow_backward":@"◀",
                     @"euro":@"💶",
                     @"anger":@"💢",
                     @"black_large_square":@"⬛",
                     @"put_litter_in_its_place":@"🚮",
                     @"saxophone":@"🎷",
                     @"mountain_bicyclist":@"🚵",
                     @"virgo":@"♍",
                     @"fishing_pole_and_fish":@"🎣",
                     @"aerial_tramway":@"🚡",
                     @"green_heart":@"💚",
                     @"white_large_square":@"⬜",
                     @"libra":@"♎",
                     @"arrow_heading_up":@"⤴",
                     @"pound":@"💷",
                     @"bomb":@"💣",
                     @"do_not_litter":@"🚯",
                     @"coffee":@"☕️",
                     @"arrow_left":@"⬅",
                     @"guitar":@"🎸",
                     @"walking":@"🚶",
                     @"microphone":@"🎤",
                     @"scorpius":@"♏",
                     @"arrow_heading_down":@"⤵",
                     @"ship":@"🚢",
                     @"mahjong":@"🀄️",
                     @"sagittarius":@"♐",
                     @"yellow_heart":@"💛",
                     @"arrow_up":@"⬆",
                     @"registered":@"®",
                     @"truck":@"🚚",
                     @"money_with_wings":@"💸",
                     @"zzz":@"💤",
                     @"capricorn":@"♑",
                     @"arrow_down":@"⬇",
                     @"scissors":@"✂",
                     @"musical_keyboard":@"🎹",
                     @"movie_camera":@"🎥",
                     @"rowboat":@"🚣",
                     @"no_pedestrians":@"🚷",
                     @"aquarius":@"♒",
                     @"purple_heart":@"💜",
                     @"cl":@"🆑",
                     @"articulated_lorry":@"🚛",
                     @"chart":@"💹",
                     @"boom":@"💥",
                     @"collision":@"💥",
                     @"pisces":@"♓",
                     @"wind_chime":@"🎐",
                     @"children_crossing":@"🚸",
                     @"cinema":@"🎦",
                     @"speedboat":@"🚤",
                     @"point_up":@"☝️",
                     @"gift_heart":@"💝",
                     @"cool":@"🆒",
                     @"white_check_mark":@"✅",
                     @"bouquet":@"💐",
                     @"kr":@"🇰🇷",
                     @"tractor":@"🚜",
                     @"tm":@"™",
                     @"confetti_ball":@"🎊",
                     @"sweat_drops":@"💦",
                     @"rice_scene":@"🎑",
                     @"mens":@"🚹",
                     @"headphones":@"🎧",
                     @"white_circle":@"⚪",
                     @"traffic_light":@"🚥",
                     @"revolving_hearts":@"💞",
                     @"pill":@"💊",
                     @"eight_pointed_black_star":@"✴️",
                     @"free":@"🆓",
                     @"couple_with_heart":@"💑",
                     @"black_circle":@"⚫",
                     @"cancer":@"♋️",
                     @"monorail":@"🚝",
                     @"arrow_backward":@"◀️",
                     @"tanabata_tree":@"🎋",
                     @"droplet":@"💧",
                     @"virgo":@"♍️",
                     @"fr":@"🇫🇷",
                     @"white_medium_square":@"◻",
                     @"school_satchel":@"🎒",
                     @"minibus":@"🚐",
                     @"one":@"1⃣",
                     @"art":@"🎨",
                     @"airplane":@"✈",
                     @"vertical_traffic_light":@"🚦",
                     @"v":@"✌️",
                     @"heart_decoration":@"💟",
                     @"black_medium_square":@"◼",
                     @"kiss":@"💋",
                     @"id":@"🆔",
                     @"wedding":@"💒",
                     @"email":@"✉",
                     @"envelope":@"✉",
                     @"mountain_railway":@"🚞",
                     @"crossed_flags":@"🎌",
                     @"dash":@"💨",
                     @"tram":@"🚊",
                     @"mortar_board":@"🎓",
                     @"white_medium_small_square":@"◽",
                     @"ambulance":@"🚑",
                     @"recycle":@"♻️",
                     @"heart":@"❤️",
                     @"tophat":@"🎩",
                     @"construction":@"🚧",
                     @"ab":@"🆎",
                     @"black_medium_small_square":@"◾",
                     @"love_letter":@"💌",
                     @"heartbeat":@"💓",
                     @"new":@"🆕",
                     @"suspension_railway":@"🚟",
                     @"ru":@"🇷🇺",
                     @"bamboo":@"🎍",
                     @"hankey":@"💩",
                     @"poop":@"💩",
                     @"shit":@"💩",
                     @"train":@"🚋",
                     @"fire_engine":@"🚒",
                     @"ribbon":@"🎀",
                     @"rotating_light":@"🚨",
                     @"arrow_up":@"⬆️",
                     @"part_alternation_mark":@"〽️",
                     @"ring":@"💍",
                     @"golf":@"⛳️",
                     @"broken_heart":@"💔",
                     @"ng":@"🆖",
                     @"skull":@"💀",
                     @"dolls":@"🎎",
                     @"bus":@"🚌",
                     @"beer":@"🍺",
                     @"police_car":@"🚓",
                     @"gift":@"🎁",
                     @"triangular_flag_on_post":@"🚩",
                     @"gem":@"💎",
                     @"japanese_goblin":@"👺",
                     @"two_hearts":@"💕",
                     @"ok":@"🆗",
                     @"information_desk_person":@"💁",
                     @"flags":@"🎏",
                     @"oncoming_bus":@"🚍",
                     @"beers":@"🍻",
                     @"sparkles":@"✨",
                     @"oncoming_police_car":@"🚔",
                     @"birthday":@"🎂",
                     @"rocket":@"🚀",
                     @"one":@"1️⃣",
                     @"couplekiss":@"💏",
                     @"ghost":@"👻",
                     @"sparkling_heart":@"💖",
                     @"sos":@"🆘",
                     @"guardsman":@"💂",
                     @"u7121":@"🈚️",
                     @"a":@"🅰",
                     @"trolleybus":@"🚎",
                     @"baby_bottle":@"🍼",
                     @"three":@"3️⃣",
                     @"ophiuchus":@"⛎",
                     @"taxi":@"🚕",
                     @"jack_o_lantern":@"🎃",
                     @"helicopter":@"🚁",
                     @"anchor":@"⚓",
                     @"congratulations":@"㊗️",
                     @"o2":@"🅾",
                     @"angel":@"👼",
                     @"rewind":@"⏪",
                     @"heartpulse":@"💗",
                     @"snowflake":@"❄",
                     @"dancer":@"💃",
                     @"up":@"🆙",
                     @"b":@"🅱",
                     @"leo":@"♌️",
                     @"busstop":@"🚏",
                     @"libra":@"♎️",
                     @"secret":@"㊙️",
                     @"star":@"⭐️",
                     @"oncoming_taxi":@"🚖",
                     @"christmas_tree":@"🎄",
                     @"steam_locomotive":@"🚂",
                     @"cake":@"🍰",
                     @"arrow_double_up":@"⏫",
                     @"two":@"2⃣",
                     @"watch":@"⌚️",
                     @"relaxed":@"☺️",
                     @"parking":@"🅿",
                     @"alien":@"👽",
                     @"sagittarius":@"♐️",
                     @"cupid":@"💘",
                     @"church":@"⛪",
                     @"lipstick":@"💄",
                     @"arrow_double_down":@"⏬",
                     @"bride_with_veil":@"👰",
                     @"cookie":@"🍪",
                     @"car":@"🚗",
                     @"red_car":@"🚗",
                     @"santa":@"🎅",
                     @"railway_car":@"🚃",
                     @"bento":@"🍱",
                     @"snowman":@"⛄️",
                     @"sparkle":@"❇",
                     @"space_invader":@"👾",
                     @"family":@"👪",
                     @"blue_heart":@"💙",
                     @"nail_care":@"💅",
                     @"no_entry":@"⛔",
                     @"person_with_blond_hair":@"👱",
                     @"chocolate_bar":@"🍫",
                     @"oncoming_automobile":@"🚘",
                     @"fireworks":@"🎆",
                     @"bullettrain_side":@"🚄",
                     @"stew":@"🍲",
                     @"arrow_left":@"⬅️",
                     @"arrow_down":@"⬇️",
                     @"alarm_clock":@"⏰",
                     @"it":@"🇮🇹",
                     @"fountain":@"⛲️",
                     @"imp":@"👿",
                     @"couple":@"👫",
                     @"massage":@"💆",
                     @"man_with_gua_pi_mao":@"👲",
                     @"candy":@"🍬",
                     @"blue_car":@"🚙",
                     @"sparkler":@"🎇",
                     @"bullettrain_front":@"🚅",
                     @"egg":@"🍳",
                     @"jp":@"🇯🇵",
                     @"heart":@"❤",
                     @"us":@"🇺🇸",
                     @"two_men_holding_hands":@"👬",
                     @"arrow_right":@"➡",
                     @"haircut":@"💇",
                     @"man_with_turban":@"👳",
                     @"hourglass_flowing_sand":@"⏳",
                     @"lollipop":@"🍭",
                     @"interrobang":@"⁉️",
                     @"balloon":@"🎈",
                     @"train2":@"🚆",
                     @"fork_and_knife":@"🍴",
                     @"arrow_right":@"➡️",
                     @"sweet_potato":@"🍠",
                     @"airplane":@"✈️",
                     @"fountain":@"⛲",
                     @"two_women_holding_hands":@"👭",
                     @"barber":@"💈",
                     @"tent":@"⛺️",
                     @"older_man":@"👴",
                     @"high_heel":@"👠",
                     @"golf":@"⛳",
                     @"custard":@"🍮",
                     @"rice":@"🍚",
                     @"tada":@"🎉",
                     @"metro":@"🚇",
                     @"tea":@"🍵",
                     @"dango":@"🍡",
                     @"clock530":@"🕠",
                     @"cop":@"👮",
                     @"womans_clothes":@"👚",
                     @"syringe":@"💉",
                     @"leftwards_arrow_with_hook":@"↩",
                     @"older_woman":@"👵",
                     @"scorpius":@"♏️",
                     @"sandal":@"👡",
                     @"clubs":@"♣️",
                     @"boat":@"⛵",
                     @"sailboat":@"⛵",
                     @"honey_pot":@"🍯",
                     @"curry":@"🍛",
                     @"light_rail":@"🚈",
                     @"three":@"3⃣",
                     @"sake":@"🍶",
                     @"oden":@"🍢",
                     @"clock11":@"🕚",
                     @"clock630":@"🕡",
                     @"hourglass":@"⌛️",
                     @"dancers":@"👯",
                     @"capricorn":@"♑️",
                     @"purse":@"👛",
                     @"loop":@"➿",
                     @"hash":@"#️⃣",
                     @"baby":@"👶",
                     @"m":@"Ⓜ",
                     @"boot":@"👢",
                     @"ramen":@"🍜",
                     @"station":@"🚉",
                     @"wine_glass":@"🍷",
                     @"watch":@"⌚",
                     @"sushi":@"🍣",
                     @"sunny":@"☀",
                     @"anchor":@"⚓️",
                     @"partly_sunny":@"⛅️",
                     @"clock12":@"🕛",
                     @"clock730":@"🕢",
                     @"ideograph_advantage":@"🉐",
                     @"hourglass":@"⌛",
                     @"handbag":@"👜",
                     @"cloud":@"☁",
                     @"construction_worker":@"👷",
                     @"footprints":@"👣",
                     @"spaghetti":@"🍝",
                     @"cocktail":@"🍸",
                     @"fried_shrimp":@"🍤",
                     @"pear":@"🍐",
                     @"clock130":@"🕜",
                     @"clock830":@"🕣",
                     @"accept":@"🉑",
                     @"boat":@"⛵️",
                     @"sailboat":@"⛵️",
                     @"pouch":@"👝",
                     @"princess":@"👸",
                     @"bust_in_silhouette":@"👤",
                     @"eight":@"8️⃣",
                     @"open_hands":@"👐",
                     @"left_right_arrow":@"↔️",
                     @"arrow_upper_left":@"↖️",
                     @"bread":@"🍞",
                     @"tangerine":@"🍊",
                     @"tropical_drink":@"🍹",
                     @"fish_cake":@"🍥",
                     @"peach":@"🍑",
                     @"clock230":@"🕝",
                     @"clock930":@"🕤",
                     @"aries":@"♈️",
                     @"clock1":@"🕐",
                     @"mans_shoe":@"👞",
                     @"shoe":@"👞",
                     @"point_up":@"☝",
                     @"facepunch":@"👊",
                     @"punch":@"👊",
                     @"japanese_ogre":@"👹",
                     @"busts_in_silhouette":@"👥",
                     @"crown":@"👑",
                     @"fries":@"🍟",
                     @"lemon":@"🍋",
                     @"icecream":@"🍦",
                     @"cherries":@"🍒",
                     @"black_small_square":@"▪",
                     @"email":@"✉️",
                     @"envelope":@"✉️",
                     @"clock330":@"🕞",
                     @"clock1030":@"🕥",
                     @"clock2":@"🕑",
                     @"m":@"Ⓜ️",
                     @"athletic_shoe":@"👟",
                     @"wave":@"👋",
                     @"white_small_square":@"▫",
                     @"boy":@"👦",
                     @"bangbang":@"‼",
                     @"womans_hat":@"👒",
                     @"banana":@"🍌",
                     @"speak_no_evil":@"🙊",
                     @"shaved_ice":@"🍧",
                     @"phone":@"☎️",
                     @"telephone":@"☎️",
                     @"strawberry":@"🍓",
                     @"clock430":@"🕟",
                     @"cn":@"🇨🇳",
                     @"clock1130":@"🕦",
                     @"clock3":@"🕒",
                     @"ok_hand":@"👌",
                     @"diamonds":@"♦️",
                     @"girl":@"👧",
                     @"relaxed":@"☺",
                     @"eyeglasses":@"👓",
                     @"pineapple":@"🍍",
                     @"raising_hand":@"🙋",
                     @"four":@"4⃣",
                     @"ice_cream":@"🍨",
                     @"information_source":@"ℹ️",
                     @"hamburger":@"🍔",
                     @"four_leaf_clover":@"🍀",
                     @"pencil2":@"✏️",
                     @"u55b6":@"🈺",
                     @"clock1230":@"🕧",
                     @"clock4":@"🕓",
                     @"part_alternation_mark":@"〽",
                     @"aquarius":@"♒️",
                     @"+1":@"👍",
                     @"thumbsup":@"👍",
                     @"like":@"👍",
                     @"man":@"👨",
                     @"necktie":@"👔",
                     @"eyes":@"👀",
                     @"bangbang":@"‼️",
                     @"apple":@"🍎",
                     @"raised_hands":@"🙌",
                     @"hibiscus":@"🌺",
                     @"doughnut":@"🍩",
                     @"pizza":@"🍕",
                     @"maple_leaf":@"🍁",
                     @"clock5":@"🕔",
                     @"gb":@"🇬🇧",
                     @"uk":@"🇬🇧",
                     @"-1":@"👎",
                     @"thumbsdown":@"👎",
                     @"wolf":@"🐺",
                     @"woman":@"👩",
                     @"shirt":@"👕",
                     @"tshirt":@"👕",
                     @"green_apple":@"🍏",
                     @"person_frowning":@"🙍",
                     @"sunflower":@"🌻",
                     @"meat_on_bone":@"🍖",
                     @"fallen_leaf":@"🍂",
                     @"scream_cat":@"🙀",
                     @"small_red_triangle":@"🔺",
                     @"clock6":@"🕕",
                     @"clap":@"👏",
                     @"bear":@"🐻",
                     @"warning":@"⚠️",
                     @"jeans":@"👖",
                     @"ear":@"👂",
                     @"arrow_up_down":@"↕️",
                     @"arrow_upper_right":@"↗️",
                     @"person_with_pouting_face":@"🙎",
                     @"blossom":@"🌼",
                     @"smiley_cat":@"😺",
                     @"poultry_leg":@"🍗",
                     @"leaves":@"🍃",
                     @"fist":@"✊",
                     @"es":@"🇪🇸",
                     @"small_red_triangle_down":@"🔻",
                     @"white_medium_square":@"◻️",
                     @"clock7":@"🕖",
                     @"tv":@"📺",
                     @"taurus":@"♉️",
                     @"de":@"🇩🇪",
                     @"panda_face":@"🐼",
                     @"hand":@"✋",
                     @"raised_hand":@"✋",
                     @"dress":@"👗",
                     @"nose":@"👃",
                     @"arrow_forward":@"▶",
                     @"pray":@"🙏",
                     @"corn":@"🌽",
                     @"heart_eyes_cat":@"😻",
                     @"rice_cracker":@"🍘",
                     @"mushroom":@"🍄",
                     @"chestnut":@"🌰",
                     @"v":@"✌",
                     @"arrow_up_small":@"🔼",
                     @"clock8":@"🕗",
                     @"radio":@"📻",
                     @"pig_nose":@"🐽",
                     @"kimono":@"👘",
                     @"lips":@"👄",
                     @"rabbit":@"🐰",
                     @"ear_of_rice":@"🌾",
                     @"smirk_cat":@"😼",
                     @"interrobang":@"⁉",
                     @"rice_ball":@"🍙",
                     @"mount_fuji":@"🗻",
                     @"tomato":@"🍅",
                     @"seedling":@"🌱",
                     @"arrow_down_small":@"🔽",
                     @"clock9":@"🕘",
                     @"vhs":@"📼",
                     @"church":@"⛪️",
                     @"beginner":@"🔰",
                     @"u7981":@"🈲",
                     @"feet":@"🐾",
                     @"paw_prints":@"🐾",
                     @"hearts":@"♥️",
                     @"dromedary_camel":@"🐪",
                     @"bikini":@"👙",
                     @"pencil2":@"✏",
                     @"tongue":@"👅",
                     @"cat":@"🐱",
                     @"european_castle":@"🏰",
                     @"herb":@"🌿",
                     @"kissing_cat":@"😽",
                     @"five":@"5⃣",
                     @"tokyo_tower":@"🗼",
                     @"seven":@"7⃣",
                     @"eggplant":@"🍆",
                     @"ballot_box_with_check":@"☑️",
                     @"spades":@"♠",
                     @"evergreen_tree":@"🌲",
                     @"cold_sweat":@"😰",
                     @"hocho":@"🔪",
                     @"knife":@"🔪",
                     @"clock10":@"🕙",
                     @"two":@"2️⃣",
                     @"trident":@"🔱",
                     @"u7a7a":@"🈳",
                     @"aries":@"♈",
                     @"newspaper":@"📰",
                     @"congratulations":@"㊗",
                     @"pisces":@"♓️",
                     @"camel":@"🐫",
                     @"point_up_2":@"👆",
                     @"convenience_store":@"🏪",
                     @"dragon_face":@"🐲",
                     @"hash":@"#⃣",
                     @"black_nib":@"✒",
                     @"pouting_cat":@"😾",
                     @"sleepy":@"😪",
                     @"statue_of_liberty":@"🗽",
                     @"taurus":@"♉",
                     @"grapes":@"🍇",
                     @"no_good":@"🙅",
                     @"deciduous_tree":@"🌳",
                     @"scream":@"😱",
                     @"wheelchair":@"♿️",
                     @"black_nib":@"✒️",
                     @"heavy_check_mark":@"✔️",
                     @"four":@"4️⃣",
                     @"gun":@"🔫",
                     @"mailbox_closed":@"📪",
                     @"black_square_button":@"🔲",
                     @"u5408":@"🈴",
                     @"secret":@"㊙",
                     @"iphone":@"📱",
                     @"recycle":@"♻",
                     @"clubs":@"♣",
                     @"dolphin":@"🐬",
                     @"flipper":@"🐬",
                     @"point_down":@"👇",
                     @"school":@"🏫",
                     @"whale":@"🐳",
                     @"heavy_check_mark":@"✔",
                     @"warning":@"⚠",
                     @"tired_face":@"😫",
                     @"japan":@"🗾",
                     @"copyright":@"©",
                     @"melon":@"🍈",
                     @"crying_cat_face":@"😿",
                     @"palm_tree":@"🌴",
                     @"astonished":@"😲",
                     @"stars":@"🌠",
                     @"ok_woman":@"🙆",
                     @"six":@"6️⃣",
                     @"microscope":@"🔬",
                     @"u7121":@"🈚",
                     @"mailbox":@"📫",
                     @"u6307":@"🈯️",
                     @"white_square_button":@"🔳",
                     @"zap":@"⚡",
                     @"u6e80":@"🈵",
                     @"calling":@"📲",
                     @"mouse":@"🐭",
                     @"zap":@"⚡️",
                     @"hearts":@"♥",
                     @"point_left":@"👈",
                     @"department_store":@"🏬",
                     @"horse":@"🐴",
                     @"arrow_lower_right":@"↘️",
                     @"tropical_fish":@"🐠",
                     @"heavy_multiplication_x":@"✖",
                     @"grimacing":@"😬",
                     @"moyai":@"🗿",
                     @"new_moon_with_face":@"🌚",
                     @"watermelon":@"🍉",
                     @"bow":@"🙇",
                     @"cactus":@"🌵",
                     @"flushed":@"😳",
                     @"diamonds":@"♦",
                     @"telescope":@"🔭",
                     @"u6307":@"🈯",
                     @"black_medium_square":@"◼️",
                     @"mailbox_with_mail":@"📬",
                     @"red_circle":@"🔴",
                     @"u6709":@"🈶",
                     @"capital_abcd":@"🔠",
                     @"vibration_mode":@"📳",
                     @"cow":@"🐮",
                     @"wheelchair":@"♿",
                     @"point_right":@"👉",
                     @"factory":@"🏭",
                     @"monkey_face":@"🐵",
                     @"shell":@"🐚",
                     @"blowfish":@"🐡",
                     @"house":@"🏠",
                     @"sob":@"😭",
                     @"first_quarter_moon_with_face":@"🌛",
                     @"see_no_evil":@"🙈",
                     @"soccer":@"⚽️",
                     @"sleeping":@"😴",
                     @"angry":@"😠",
                     @"hotsprings":@"♨",
                     @"crystal_ball":@"🔮",
                     @"end":@"🔚",
                     @"mailbox_with_no_mail":@"📭",
                     @"large_blue_circle":@"🔵",
                     @"soccer":@"⚽",
                     @"abcd":@"🔡",
                     @"mobile_phone_off":@"📴",
                     @"u6708":@"🈷",
                     @"fax":@"📠",
                     @"tiger":@"🐯",
                     @"star":@"⭐",
                     @"bug":@"🐛",
                     @"izakaya_lantern":@"🏮",
                     @"lantern":@"🏮",
                     @"fuelpump":@"⛽️",
                     @"dog":@"🐶",
                     @"turtle":@"🐢",
                     @"house_with_garden":@"🏡",
                     @"open_mouth":@"😮",
                     @"baseball":@"⚾",
                     @"last_quarter_moon_with_face":@"🌜",
                     @"kissing_closed_eyes":@"😚",
                     @"hear_no_evil":@"🙉",
                     @"tulip":@"🌷",
                     @"eight_spoked_asterisk":@"✳",
                     @"rage":@"😡",
                     @"dizzy_face":@"😵",
                     @"six_pointed_star":@"🔯",
                     @"on":@"🔛",
                     @"postbox":@"📮",
                     @"u7533":@"🈸",
                     @"large_orange_diamond":@"🔶",
                     @"1234":@"🔢",
                     @"no_mobile_phones":@"📵",
                     @"books":@"📚",
                     @"satellite":@"📡",
                     @"x":@"❌",
                     @"eight_pointed_black_star":@"✴",
                     @"ant":@"🐜",
                     @"japanese_castle":@"🏯",
                     @"hotsprings":@"♨️",
                     @"pig":@"🐷",
                     @"hatching_chick":@"🐣",
                     @"office":@"🏢",
                     @"hushed":@"😯",
                     @"six":@"6⃣",
                     @"full_moon_with_face":@"🌝",
                     @"stuck_out_tongue":@"😛",
                     @"eight":@"8⃣",
                     @"cherry_blossom":@"🌸",
                     @"information_source":@"ℹ",
                     @"cry":@"😢",
                     @"no_mouth":@"😶",
                     @"globe_with_meridians":@"🌐",
                     @"arrow_heading_up":@"⤴️",
                     @"soon":@"🔜",
                     @"postal_horn":@"📯",
                     @"u5272":@"🈹",
                     @"large_blue_diamond":@"🔷",
                     @"symbols":@"🔣",
                     @"signal_strength":@"📶",
                     @"name_badge":@"📛",
                     @"loudspeaker":@"📢",
                     @"negative_squared_cross_mark":@"❎",
                     @"arrow_right_hook":@"↪️",
                     @"bee":@"🐝",
                     @"honeybee":@"🐝",
                     @"sunny":@"☀️",
                     @"frog":@"🐸",
                     @"baby_chick":@"🐤",
                     @"goat":@"🐐",
                     @"post_office":@"🏣",
                     @"sun_with_face":@"🌞",
                     @"stuck_out_tongue_winking_eye":@"😜",
                     @"ocean":@"🌊",
                     @"rose":@"🌹",
                     @"mask":@"😷",
                     @"persevere":@"😣",
                     @"o":@"⭕",
                     @"new_moon":@"🌑",
                     @"top":@"🔝",
                     @"small_orange_diamond":@"🔸",
                     @"scroll":@"📜",
                     @"abc":@"🔤",
                     @"camera":@"📷",
                     @"closed_lock_with_key":@"🔐",
                     @"mega":@"📣",
                     @"beetle":@"🐞",
                     @"snowman":@"⛄",
                     @"crocodile":@"🐊",
                     @"hamster":@"🐹",
                     @"exclamation":@"❗️",
                     @"heavy_exclamation_mark":@"❗️",
                     @"hatched_chick":@"🐥",
                     @"sheep":@"🐑",
                     @"european_post_office":@"🏤",
                     @"star2":@"🌟",
                     @"arrow_right_hook":@"↪",
                     @"volcano":@"🌋",
                     @"stuck_out_tongue_closed_eyes":@"😝",
                     @"smile_cat":@"😸",
                     @"triumph":@"😤",
                     @"waxing_crescent_moon":@"🌒",
                     @"partly_sunny":@"⛅",
                     @"neutral_face":@"😐",
                     @"underage":@"🔞",
                     @"loud_sound":@"🔊",
                     @"small_blue_diamond":@"🔹",
                     @"memo":@"📝",
                     @"pencil":@"📝",
                     @"fire":@"🔥",
                     @"key":@"🔑",
                     @"outbox_tray":@"📤",
                     @"triangular_ruler":@"📐",
                     @"fish":@"🐟",
                     @"whale2":@"🐋",
                     @"arrow_lower_left":@"↙️",
                     @"bird":@"🐦",
                     @"question":@"❓",
                     @"monkey":@"🐒",
                     @"hospital":@"🏥",
                     @"swimmer":@"🏊",
                     @"disappointed":@"😞",
                     @"milky_way":@"🌌",
                     @"blush":@"😊",
                     @"joy_cat":@"😹",
                     @"disappointed_relieved":@"😥",
                     @"first_quarter_moon":@"🌓",
                     @"expressionless":@"😑",
                     @"keycap_ten":@"🔟",
                     @"grey_question":@"❔",
                     @"battery":@"🔋",
                     @"telephone_receiver":@"📞",
                     @"white_medium_small_square":@"◽️",
                     @"bar_chart":@"📊",
                     @"video_camera":@"📹",
                     @"flashlight":@"🔦",
                     @"inbox_tray":@"📥",
                     @"lock":@"🔒",
                     @"bookmark_tabs":@"📑",
                     @"snail":@"🐌",
                     @"penguin":@"🐧",
                     @"grey_exclamation":@"❕",
                     @"rooster":@"🐓",
                     @"bank":@"🏦",
                     @"worried":@"😟",
                     @"baseball":@"⚾️",
                     @"earth_africa":@"🌍",
                     @"yum":@"😋",
                     @"frowning":@"😦",
                     @"moon":@"🌔",
                     @"waxing_gibbous_moon":@"🌔",
                     @"unamused":@"😒",
                     @"cyclone":@"🌀",
                     @"tent":@"⛺",
                     @"electric_plug":@"🔌",
                     @"pager":@"📟",
                     @"clipboard":@"📋",
                     @"wrench":@"🔧",
                     @"unlock":@"🔓",
                     @"package":@"📦",
                     @"koko":@"🈁",
                     @"ledger":@"📒",
                     @"snake":@"🐍",
                     @"koala":@"🐨",
                     @"chicken":@"🐔",
                     @"atm":@"🏧",
                     @"exclamation":@"❗",
                     @"heavy_exclamation_mark":@"❗",
                     @"rat":@"🐀",
                     @"white_circle":@"⚪️",
                     @"earth_americas":@"🌎",
                     @"relieved":@"😌",
                     @"nine":@"9️⃣",
                     @"anguished":@"😧",
                     @"full_moon":@"🌕",
                     @"sweat":@"😓",
                     @"foggy":@"🌁",
                     @"mag":@"🔍",
                     @"pushpin":@"📌",
                     @"hammer":@"🔨",
                     @"bell":@"🔔",
                     @"e-mail":@"📧",
                     @"sa":@"🈂",
                     @"notebook":@"📓",
                     @"twisted_rightwards_arrows":@"🔀",
                     @"zero":@"0️⃣",
                     @"racehorse":@"🐎",
                     
                     @"doge":@"🐶",
                     @"<3":@"❤️",
                     @"</3":@"💔",
                     @")":@"😃",
                     @"-)":@"😃",
                     @"(":@"😞",
                     @"'(":@"😢",
                     @"_(":@"😭",
                     @";)":@"😉",
                     @";p":@"😜",
                     @"simple_smile":@":)",
                     @"slightly_smiling_face":@":)"};
    
    static NSRegularExpression *_pattern;
    if(!_pattern) {
        NSError *err;
        NSString *pattern = [NSString stringWithFormat:@"\\B:(%@):\\B", [[[[[emojiMap.allKeys componentsJoinedByString:@"|"] stringByReplacingOccurrencesOfString:@"-" withString:@"\\-"] stringByReplacingOccurrencesOfString:@"+" withString:@"\\+"] stringByReplacingOccurrencesOfString:@"(" withString:@"\\("] stringByReplacingOccurrencesOfString:@")" withString:@"\\)"]];
        _pattern = [NSRegularExpression
                    regularExpressionWithPattern:pattern
                    options:NSRegularExpressionCaseInsensitive
                    error:&err];
    }
    return _pattern;
}

+(NSRegularExpression *)spotify {
    static NSRegularExpression *_pattern = nil;
    if(!_pattern) {
        NSString *pattern = @"spotify:([^<>\"\\s]+)";
        _pattern = [NSRegularExpression
                    regularExpressionWithPattern:pattern
                    options:NSRegularExpressionCaseInsensitive
                    error:nil];
    }
    return _pattern;
}

+(NSRegularExpression *)email {
    static NSRegularExpression *_pattern = nil;
    if(!_pattern) {
        //Ported from Android: https://github.com/android/platform_frameworks_base/blob/master/core/java/android/util/Patterns.java
        NSString *pattern = @"[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}\\@[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})+";
        _pattern = [NSRegularExpression
                    regularExpressionWithPattern:pattern
                    options:NSRegularExpressionCaseInsensitive
                    error:nil];
    }
    return _pattern;
}

+(NSRegularExpression *)webURL {
    static NSRegularExpression *_pattern = nil;
    if(!_pattern) {
    //Ported from Android: https://github.com/android/platform_frameworks_base/blob/master/core/java/android/util/Patterns.java
    NSString *TOP_LEVEL_DOMAIN_STR_FOR_WEB_URL = @"(?:\
(?:aaa|aarp|abb|abbott|abbvie|abogado|abudhabi|academy|accenture|accountant|accountants|aco|active|actor|adac|ads|adult|aeg|aero|aetna|afl|agakhan|agency|aig|airbus|airforce|airtel|akdn|alibaba|alipay|allfinanz|ally|alsace|alstom|amica|amsterdam|analytics|android|anquan|apartments|app|apple|aquarelle|aramco|archi|army|arpa|arte|asia|associates|attorney|auction|audi|audible|audio|author|auto|autos|avianca|aws|axa|azure|a[cdefgilmoqrstuwxz])\
|(?:baby|baidu|band|bank|bar|barcelona|barclaycard|barclays|barefoot|bargains|bauhaus|bayern|bbc|bbva|bcg|bcn|beats|beer|bentley|berlin|best|bet|bharti|bible|bid|bike|bing|bingo|bio|biz|black|blackfriday|blog|bloomberg|blue|bms|bmw|bnl|bnpparibas|boats|boehringer|bom|bond|boo|book|boots|bosch|bostik|bot|boutique|bradesco|bridgestone|broadway|broker|brother|brussels|budapest|bugatti|build|builders|business|buy|buzz|bzh|b[abdefghijmnorstvwyz])\
|(?:cab|cafe|cal|call|camera|camp|cancerresearch|canon|capetown|capital|car|caravan|cards|care|career|careers|cars|cartier|casa|cash|casino|cat|catering|cba|cbn|ceb|center|ceo|cern|cfa|cfd|chanel|channel|chase|chat|cheap|chintai|chloe|christmas|chrome|church|cipriani|circle|cisco|citic|city|cityeats|claims|cleaning|click|clinic|clinique|clothing|cloud|club|clubmed|coach|codes|coffee|college|cologne|com|commbank|community|company|compare|computer|comsec|condos|construction|consulting|contact|contractors|cooking|cool|coop|corsica|country|coupon|coupons|courses|credit|creditcard|creditunion|cricket|crown|crs|cruises|csc|cuisinella|cymru|cyou|c[acdfghiklmnoruvwxyz])\
|(?:dabur|dad|dance|date|dating|datsun|day|dclk|dds|deal|dealer|deals|degree|delivery|dell|deloitte|delta|democrat|dental|dentist|desi|design|dev|dhl|diamonds|diet|digital|direct|directory|discount|dnp|docs|dog|doha|domains|dot|download|drive|dtv|dubai|dunlop|dupont|durban|dvag|d[ejkmoz])\
|(?:earth|eat|edeka|edu|education|email|emerck|energy|engineer|engineering|enterprises|epost|epson|equipment|ericsson|erni|esq|estate|eurovision|eus|events|everbank|exchange|expert|exposed|express|extraspace|e[cegrstu])\
|(?:fage|fail|fairwinds|faith|family|fan|fans|farm|fashion|fast|feedback|ferrero|film|final|finance|financial|fire|firestone|firmdale|fish|fishing|fit|fitness|flickr|flights|flir|florist|flowers|flsmidth|fly|foo|football|ford|forex|forsale|forum|foundation|fox|fresenius|frl|frogans|frontier|ftr|fund|furniture|futbol|fyi|f[ijkmor])\
|(?:gal|gallery|gallo|gallup|game|games|garden|gbiz|gdn|gea|gent|genting|ggee|gift|gifts|gives|giving|glass|gle|global|globo|gmail|gmbh|gmo|gmx|gold|goldpoint|golf|goo|goodyear|goog|google|gop|got|gov|grainger|graphics|gratis|green|gripe|group|guardian|gucci|guge|guide|guitars|guru|g[abdefghilmnpqrstuwy])\
|(?:hamburg|hangout|haus|hdfcbank|health|healthcare|help|helsinki|here|hermes|hiphop|hisamitsu|hitachi|hiv|hkt|hockey|holdings|holiday|homedepot|homes|honda|horse|host|hosting|hoteles|hotmail|house|how|hsbc|htc|hyundai|h[kmnrtu])\
|(?:ibm|icbc|ice|icu|ifm|iinet|imamat|imdb|immo|immobilien|industries|infiniti|info|ing|ink|institute|insurance|insure|int|international|investments|ipiranga|irish|iselect|ismaili|ist|istanbul|itau|iwc|i[delmnoqrst])\
|(?:jaguar|java|jcb|jcp|jetzt|jewelry|jlc|jll|jmp|jnj|jobs|joburg|jot|joy|jpmorgan|jprs|juegos|j[emop])\
|(?:kaufen|kddi|kerryhotels|kerrylogistics|kerryproperties|kfh|kia|kim|kinder|kindle|kitchen|kiwi|koeln|komatsu|kosher|kpmg|kpn|krd|kred|kuokgroup|kyoto|k[eghimnprwyz])\
|(?:lacaixa|lamborghini|lamer|lancaster|land|landrover|lanxess|lasalle|lat|latrobe|law|lawyer|lds|lease|leclerc|legal|lexus|lgbt|liaison|lidl|life|lifeinsurance|lifestyle|lighting|like|limited|limo|lincoln|linde|link|lipsy|live|living|lixil|loan|loans|locker|locus|lol|london|lotte|lotto|love|ltd|ltda|lupin|luxe|luxury|l[abcikrstuvy])\
|(?:madrid|maif|maison|makeup|man|management|mango|market|marketing|markets|marriott|mattel|mba|med|media|meet|melbourne|meme|memorial|men|menu|meo|metlife|miami|microsoft|mil|mini|mlb|mls|mma|mobi|mobily|moda|moe|moi|mom|monash|money|montblanc|mormon|mortgage|moscow|motorcycles|mov|movie|movistar|mtn|mtpc|mtr|museum|mutual|mutuelle|m[acdeghklmnopqrstuvwxyz])\
|(?:nadex|nagoya|name|natura|navy|nec|net|netbank|netflix|network|neustar|new|news|next|nextdirect|nexus|ngo|nhk|nico|nikon|ninja|nissan|nissay|nokia|northwesternmutual|norton|now|nowruz|nowtv|nra|nrw|ntt|nyc|n[acefgilopruz])\
|(?:obi|office|okinawa|olayan|olayangroup|ollo|omega|one|ong|onl|online|ooo|oracle|orange|org|organic|origins|osaka|otsuka|ott|ovh|om)\
|(?:page|pamperedchef|panerai|paris|pars|partners|parts|party|passagens|pccw|pet|pharmacy|philips|photo|photography|photos|physio|piaget|pics|pictet|pictures|pid|pin|ping|pink|pioneer|pizza|place|play|playstation|plumbing|plus|pohl|poker|porn|post|praxi|press|prime|pro|prod|productions|prof|progressive|promo|properties|property|protection|pub|pwc|p[aefghklmnrstwy])\
|(?:qpon|quebec|quest|qa)\
|(?:racing|read|realestate|realtor|realty|recipes|red|redstone|redumbrella|rehab|reise|reisen|reit|ren|rent|rentals|repair|report|republican|rest|restaurant|review|reviews|rexroth|rich|richardli|ricoh|rio|rip|rocher|rocks|rodeo|room|rsvp|ruhr|run|rwe|ryukyu|r[eosuw])\
|(?:saarland|safe|safety|sakura|sale|salon|samsung|sandvik|sandvikcoromant|sanofi|sap|sapo|sarl|sas|save|saxo|sbi|sbs|sca|scb|schaeffler|schmidt|scholarships|school|schule|schwarz|science|scor|scot|seat|security|seek|select|sener|services|seven|sew|sex|sexy|sfr|sharp|shaw|shell|shia|shiksha|shoes|shop|shouji|show|shriram|silk|sina|singles|site|ski|skin|sky|skype|smile|sncf|soccer|social|softbank|software|sohu|solar|solutions|song|sony|soy|space|spiegel|spot|spreadbetting|srl|stada|star|starhub|statebank|statefarm|statoil|stc|stcgroup|stockholm|storage|store|stream|studio|study|style|sucks|supplies|supply|support|surf|surgery|suzuki|swatch|swiss|sydney|symantec|systems|s[abcdeghijklmnortuvxyz])\
|(?:tab|taipei|talk|taobao|tatamotors|tatar|tattoo|tax|taxi|tci|tdk|team|tech|technology|tel|telecity|telefonica|temasek|tennis|teva|thd|theater|theatre|tickets|tienda|tiffany|tips|tires|tirol|tmall|today|tokyo|tools|top|toray|toshiba|total|tours|town|toyota|toys|trade|trading|training|travel|travelers|travelersinsurance|trust|trv|tube|tui|tunes|tushu|tvs|t[cdfghjklmnortvwz])\
|(?:ubs|unicom|university|uno|uol|ups|u[agksyz])\
|(?:vacations|vana|vegas|ventures|verisign|versicherung|vet|viajes|video|vig|viking|villas|vin|vip|virgin|vision|vista|vistaprint|viva|vlaanderen|vodka|volkswagen|vote|voting|voto|voyage|vuelos|v[aceginu])\
|(?:wales|walter|wang|wanggou|warman|watch|watches|weather|weatherchannel|webcam|weber|website|wed|wedding|weibo|weir|whoswho|wien|wiki|williamhill|win|windows|wine|wme|wolterskluwer|work|works|world|wtc|wtf|w[fs])\
|(?:\\u03b5\\u03bb|\\u0431\\u0435\\u043b|\\u0434\\u0435\\u0442\\u0438|\\u0435\\u044e|\\u043a\\u043e\\u043c|\\u043c\\u043a\\u0434|\\u043c\\u043e\\u043d|\\u043c\\u043e\\u0441\\u043a\\u0432\\u0430|\\u043e\\u043d\\u043b\\u0430\\u0439\\u043d|\\u043e\\u0440\\u0433|\\u0440\\u0443\\u0441|\\u0440\\u0444|\\u0441\\u0430\\u0439\\u0442|\\u0441\\u0440\\u0431|\\u0443\\u043a\\u0440|\\u049b\\u0430\\u0437|\\u0570\\u0561\\u0575|\\u05e7\\u05d5\\u05dd|\\u0627\\u0628\\u0648\\u0638\\u0628\\u064a|\\u0627\\u0631\\u0627\\u0645\\u0643\\u0648|\\u0627\\u0644\\u0627\\u0631\\u062f\\u0646|\\u0627\\u0644\\u062c\\u0632\\u0627\\u0626\\u0631|\\u0627\\u0644\\u0633\\u0639\\u0648\\u062f\\u064a\\u0629|\\u0627\\u0644\\u0639\\u0644\\u064a\\u0627\\u0646|\\u0627\\u0644\\u0645\\u063a\\u0631\\u0628|\\u0627\\u0645\\u0627\\u0631\\u0627\\u062a|\\u0627\\u06cc\\u0631\\u0627\\u0646|\\u0628\\u0627\\u0632\\u0627\\u0631|\\u0628\\u064a\\u062a\\u0643|\\u0628\\u06be\\u0627\\u0631\\u062a|\\u062a\\u0648\\u0646\\u0633|\\u0633\\u0648\\u062f\\u0627\\u0646|\\u0633\\u0648\\u0631\\u064a\\u0629|\\u0634\\u0628\\u0643\\u0629|\\u0639\\u0631\\u0627\\u0642|\\u0639\\u0645\\u0627\\u0646|\\u0641\\u0644\\u0633\\u0637\\u064a\\u0646|\\u0642\\u0637\\u0631|\\u0643\\u0648\\u0645|\\u0645\\u0635\\u0631|\\u0645\\u0644\\u064a\\u0633\\u064a\\u0627|\\u0645\\u0648\\u0628\\u0627\\u064a\\u0644\\u064a|\\u0645\\u0648\\u0642\\u0639|\\u0647\\u0645\\u0631\\u0627\\u0647|\\u0915\\u0949\\u092e|\\u0928\\u0947\\u091f|\\u092d\\u093e\\u0930\\u0924|\\u0938\\u0902\\u0917\\u0920\\u0928|\\u09ad\\u09be\\u09b0\\u09a4|\\u0a2d\\u0a3e\\u0a30\\u0a24|\\u0aad\\u0abe\\u0ab0\\u0aa4|\\u0b87\\u0ba8\\u0bcd\\u0ba4\\u0bbf\\u0baf\\u0bbe|\\u0b87\\u0bb2\\u0b99\\u0bcd\\u0b95\\u0bc8|\\u0b9a\\u0bbf\\u0b99\\u0bcd\\u0b95\\u0baa\\u0bcd\\u0baa\\u0bc2\\u0bb0\\u0bcd|\\u0c2d\\u0c3e\\u0c30\\u0c24\\u0c4d|\\u0dbd\\u0d82\\u0d9a\\u0dcf|\\u0e04\\u0e2d\\u0e21|\\u0e44\\u0e17\\u0e22|\\u10d2\\u10d4|\\u307f\\u3093\\u306a|\\u30af\\u30e9\\u30a6\\u30c9|\\u30b0\\u30fc\\u30b0\\u30eb|\\u30b3\\u30e0|\\u30b9\\u30c8\\u30a2|\\u30bb\\u30fc\\u30eb|\\u30d5\\u30a1\\u30c3\\u30b7\\u30e7\\u30f3|\\u30dd\\u30a4\\u30f3\\u30c8|\\u4e16\\u754c|\\u4e2d\\u4fe1|\\u4e2d\\u56fd|\\u4e2d\\u570b|\\u4e2d\\u6587\\u7f51|\\u4f01\\u4e1a|\\u4f5b\\u5c71|\\u4fe1\\u606f|\\u5065\\u5eb7|\\u516b\\u5366|\\u516c\\u53f8|\\u516c\\u76ca|\\u53f0\\u6e7e|\\u53f0\\u7063|\\u5546\\u57ce|\\u5546\\u5e97|\\u5546\\u6807|\\u5609\\u91cc|\\u5609\\u91cc\\u5927\\u9152\\u5e97|\\u5728\\u7ebf|\\u5927\\u62ff|\\u5a31\\u4e50|\\u5bb6\\u96fb|\\u5de5\\u884c|\\u5e7f\\u4e1c|\\u5fae\\u535a|\\u6148\\u5584|\\u6211\\u7231\\u4f60|\\u624b\\u673a|\\u624b\\u8868|\\u653f\\u52a1|\\u653f\\u5e9c|\\u65b0\\u52a0\\u5761|\\u65b0\\u95fb|\\u65f6\\u5c1a|\\u66f8\\u7c4d|\\u673a\\u6784|\\u6de1\\u9a6c\\u9521|\\u6e38\\u620f|\\u6fb3\\u9580|\\u70b9\\u770b|\\u73e0\\u5b9d|\\u79fb\\u52a8|\\u7ec4\\u7ec7\\u673a\\u6784|\\u7f51\\u5740|\\u7f51\\u5e97|\\u7f51\\u7ad9|\\u7f51\\u7edc|\\u8054\\u901a|\\u8bfa\\u57fa\\u4e9a|\\u8c37\\u6b4c|\\u8d2d\\u7269|\\u96c6\\u56e2|\\u96fb\\u8a0a\\u76c8\\u79d1|\\u98de\\u5229\\u6d66|\\u98df\\u54c1|\\u9910\\u5385|\\u9999\\u6e2f|\\ub2f7\\ub137|\\ub2f7\\ucef4|\\uc0bc\\uc131|\\ud55c\\uad6d|verm\\xf6gensberater|verm\\xf6gensberatung|xbox|xerox|xihuan|xin|xn\\-\\-11b4c3d|xn\\-\\-1ck2e1b|xn\\-\\-1qqw23a|xn\\-\\-30rr7y|xn\\-\\-3bst00m|xn\\-\\-3ds443g|xn\\-\\-3e0b707e|xn\\-\\-3pxu8k|xn\\-\\-42c2d9a|xn\\-\\-45brj9c|xn\\-\\-45q11c|xn\\-\\-4gbrim|xn\\-\\-55qw42g|xn\\-\\-55qx5d|xn\\-\\-5tzm5g|xn\\-\\-6frz82g|xn\\-\\-6qq986b3xl|xn\\-\\-80adxhks|xn\\-\\-80ao21a|xn\\-\\-80asehdb|xn\\-\\-80aswg|xn\\-\\-8y0a063a|xn\\-\\-90a3ac|xn\\-\\-90ais|xn\\-\\-9dbq2a|xn\\-\\-9et52u|xn\\-\\-9krt00a|xn\\-\\-b4w605ferd|xn\\-\\-bck1b9a5dre4c|xn\\-\\-c1avg|xn\\-\\-c2br7g|xn\\-\\-cck2b3b|xn\\-\\-cg4bki|xn\\-\\-clchc0ea0b2g2a9gcd|xn\\-\\-czr694b|xn\\-\\-czrs0t|xn\\-\\-czru2d|xn\\-\\-d1acj3b|xn\\-\\-d1alf|xn\\-\\-e1a4c|xn\\-\\-eckvdtc9d|xn\\-\\-efvy88h|xn\\-\\-estv75g|xn\\-\\-fct429k|xn\\-\\-fhbei|xn\\-\\-fiq228c5hs|xn\\-\\-fiq64b|xn\\-\\-fiqs8s|xn\\-\\-fiqz9s|xn\\-\\-fjq720a|xn\\-\\-flw351e|xn\\-\\-fpcrj9c3d|xn\\-\\-fzc2c9e2c|xn\\-\\-fzys8d69uvgm|xn\\-\\-g2xx48c|xn\\-\\-gckr3f0f|xn\\-\\-gecrj9c|xn\\-\\-h2brj9c|xn\\-\\-hxt814e|xn\\-\\-i1b6b1a6a2e|xn\\-\\-imr513n|xn\\-\\-io0a7i|xn\\-\\-j1aef|xn\\-\\-j1amh|xn\\-\\-j6w193g|xn\\-\\-jlq61u9w7b|xn\\-\\-jvr189m|xn\\-\\-kcrx77d1x4a|xn\\-\\-kprw13d|xn\\-\\-kpry57d|xn\\-\\-kpu716f|xn\\-\\-kput3i|xn\\-\\-l1acc|xn\\-\\-lgbbat1ad8j|xn\\-\\-mgb9awbf|xn\\-\\-mgba3a3ejt|xn\\-\\-mgba3a4f16a|xn\\-\\-mgba7c0bbn0a|xn\\-\\-mgbaam7a8h|xn\\-\\-mgbab2bd|xn\\-\\-mgbayh7gpa|xn\\-\\-mgbb9fbpob|xn\\-\\-mgbbh1a71e|xn\\-\\-mgbc0a9azcg|xn\\-\\-mgbca7dzdo|xn\\-\\-mgberp4a5d4ar|xn\\-\\-mgbpl2fh|xn\\-\\-mgbt3dhd|xn\\-\\-mgbtx2b|xn\\-\\-mgbx4cd0ab|xn\\-\\-mix891f|xn\\-\\-mk1bu44c|xn\\-\\-mxtq1m|xn\\-\\-ngbc5azd|xn\\-\\-ngbe9e0a|xn\\-\\-node|xn\\-\\-nqv7f|xn\\-\\-nqv7fs00ema|xn\\-\\-nyqy26a|xn\\-\\-o3cw4h|xn\\-\\-ogbpf8fl|xn\\-\\-p1acf|xn\\-\\-p1ai|xn\\-\\-pbt977c|xn\\-\\-pgbs0dh|xn\\-\\-pssy2u|xn\\-\\-q9jyb4c|xn\\-\\-qcka1pmc|xn\\-\\-qxam|xn\\-\\-rhqv96g|xn\\-\\-rovu88b|xn\\-\\-s9brj9c|xn\\-\\-ses554g|xn\\-\\-t60b56a|xn\\-\\-tckwe|xn\\-\\-unup4y|xn\\-\\-vermgensberater\\-ctb|xn\\-\\-vermgensberatung\\-pwb|xn\\-\\-vhquv|xn\\-\\-vuq861b|xn\\-\\-w4r85el8fhu5dnra|xn\\-\\-w4rs40l|xn\\-\\-wgbh1c|xn\\-\\-wgbl6a|xn\\-\\-xhq521b|xn\\-\\-xkc2al3hye2a|xn\\-\\-xkc2dl3a5ee0h|xn\\-\\-y9a3aq|xn\\-\\-yfro4i67o|xn\\-\\-ygbi2ammx|xn\\-\\-zfr164b|xperia|xxx|xyz)\
|(?:yachts|yahoo|yamaxun|yandex|yodobashi|yoga|yokohama|you|youtube|yun|y[et])\
|(?:zappos|zara|zero|zip|zone|zuerich|z[amw])))";
    NSString *GOOD_IRI_CHAR = @"a-zA-Z0-9\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF";
    NSString *pattern = [NSString stringWithFormat:@"((?:[a-z_-]+:\\/{1,3}(?:(?:[a-zA-Z0-9\\$\\-\\_\\.\\+\\!\\*\\'\\(\\)\
\\,\\;\\?\\&\\=]|(?:\\%%[a-fA-F0-9]{2})){1,64}(?:\\:(?:[a-zA-Z0-9\\$\\-\\_\
\\.\\+\\!\\*\\'\\(\\)\\,\\;\\?\\&\\=]|(?:\\%%[a-fA-F0-9]{2})){1,25})?\\@)?)?\
((?:(?:[%@][%@\\-]{0,64}\\.)+%@\
|(?:(?:25[0-5]|2[0-4]\
[0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9])\\.(?:25[0-5]|2[0-4][0-9]\
|[0-1][0-9]{2}|[1-9][0-9]|[1-9]|0)\\.(?:25[0-5]|2[0-4][0-9]|[0-1]\
[0-9]{2}|[1-9][0-9]|[1-9]|0)\\.(?:25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}\
|[1-9][0-9]|[0-9])))\
(?:\\:\\d{1,5})?)\
([\\/\\?\\#](?:(?:[%@\\;\\/\\?\\:\\@\\&\\=\\#\\~\\$\
\\-\\.\\+\\!\\*\\'\\(\\)\\,\\_\\^\\{\\}\\[\\]\\|])|(?:\\%%[a-fA-F0-9]{2}))*)?\
(?:\\b|$)", GOOD_IRI_CHAR, GOOD_IRI_CHAR, TOP_LEVEL_DOMAIN_STR_FOR_WEB_URL, GOOD_IRI_CHAR];
    _pattern = [NSRegularExpression
            regularExpressionWithPattern:pattern
            options:NSRegularExpressionCaseInsensitive
            error:nil];
    }
    return _pattern;
}

+(NSRegularExpression *)ircChannelRegexForServer:(Server *)s {
    NSString *pattern;
    if(s && s.CHANTYPES.length) {
        pattern = [NSString stringWithFormat:@"(\\s|^)([%@][^\\ufe0e\\ufe0f\\u20e3<>\",\\s\\u0001][^<>\",\\s\\u0001]*)", s.CHANTYPES];
    } else {
        pattern = [NSString stringWithFormat:@"(\\s|^)([#][^\\ufe0e\\ufe0f\\u20e3<>\",\\s\\u0001][^<>\",\\s\\u0001]*)"];
    }
    
    return [NSRegularExpression
            regularExpressionWithPattern:pattern
            options:NSRegularExpressionCaseInsensitive
            error:nil];
}

+(BOOL)unbalanced:(NSString *)input {
    if(!quotes)
        quotes = @{@"\"":@"\"",@"'": @"'",@")": @"(",@"]": @"[",@"}": @"{",@">": @"<",@"”": @"“",@"’": @"‘",@"»": @"«"};
    
    NSString *lastChar = [input substringFromIndex:input.length - 1];
    
    return [quotes objectForKey:lastChar] && [input componentsSeparatedByString:lastChar].count != [input componentsSeparatedByString:[quotes objectForKey:lastChar]].count;
}

+(void)setFont:(id)font start:(int)start length:(int)length attributes:(NSMutableArray *)attributes {
    [attributes addObject:@{NSFontAttributeName:font,
                            @"start":@(start),
                            @"length":@(length)
                            }];
}

+(void)loadFonts {
    monoTimestampFont = [UIFont fontWithName:@"Courier" size:FONT_SIZE - 2];
    timestampFont = [UIFont systemFontOfSize:FONT_SIZE - 2];
    awesomeFont = [UIFont fontWithName:@"FontAwesome" size:FONT_SIZE];
    arrowFont = [UIFont fontWithName:@"HiraMinProN-W3" size:FONT_SIZE];
    Courier = [UIFont fontWithName:@"Courier" size:FONT_SIZE];
    CourierBold = [UIFont fontWithName:@"Courier-Bold" size:FONT_SIZE];
    CourierOblique = [UIFont fontWithName:@"Courier-Oblique" size:FONT_SIZE];
    CourierBoldOblique = [UIFont fontWithName:@"Courier-BoldOblique" size:FONT_SIZE];
    chalkboardFont = [UIFont fontWithName:@"ChalkboardSE-Light" size:FONT_SIZE];
    markerFont = [UIFont fontWithName:@"MarkerFelt-Thin" size:FONT_SIZE];
    UIFontDescriptor *bodyFontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    UIFontDescriptor *boldBodyFontDescriptor = [bodyFontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    UIFontDescriptor *italicBodyFontDescriptor = [bodyFontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
    UIFontDescriptor *boldItalicBodyFontDescriptor = [bodyFontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold|UIFontDescriptorTraitItalic];
    Helvetica = [UIFont fontWithDescriptor:bodyFontDescriptor size:FONT_SIZE];
    HelveticaBold = [UIFont fontWithDescriptor:boldBodyFontDescriptor size:FONT_SIZE];
    HelveticaOblique = [UIFont fontWithDescriptor:italicBodyFontDescriptor size:FONT_SIZE];
    HelveticaBoldOblique = [UIFont fontWithDescriptor:boldItalicBodyFontDescriptor size:FONT_SIZE];
    ColorFormatterCachedFontSize = FONT_SIZE;
}

+(NSAttributedString *)format:(NSString *)input defaultColor:(UIColor *)color mono:(BOOL)mono linkify:(BOOL)linkify server:(Server *)server links:(NSArray **)links {
    if(!color)
        color = [UIColor messageTextColor];
    
    int bold = -1, italics = -1, underline = -1, fg = -1, bg = -1;
    UIColor *fgColor = nil, *bgColor = nil;
    id font, boldFont, italicFont, boldItalicFont;
    NSMutableArray *matches = [[NSMutableArray alloc] init];
    
    if(!Courier) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self loadFonts];
        });
    }
    
    if(mono) {
        font = Courier;
        boldFont = CourierBold;
        italicFont = CourierOblique;
        boldItalicFont = CourierBoldOblique;
    } else {
        font = Helvetica;
        boldFont = HelveticaBold;
        italicFont = HelveticaOblique;
        boldItalicFont = HelveticaBoldOblique;
    }
    NSMutableArray *attributes = [[NSMutableArray alloc] init];
    NSMutableArray *arrowIndex = [[NSMutableArray alloc] init];
    
    NSMutableString *text = [[NSMutableString alloc] initWithFormat:@"%@%c", input, CLEAR];
    BOOL disableConvert = [[NetworkConnection sharedInstance] prefs] && [[[[NetworkConnection sharedInstance] prefs] objectForKey:@"emoji-disableconvert"] boolValue];
    if(!disableConvert) {
        NSInteger offset = 0;
        NSArray *results = [[self emoji] matchesInString:[text lowercaseString] options:0 range:NSMakeRange(0, text.length)];
        for(NSTextCheckingResult *result in results) {
            for(int i = 1; i < result.numberOfRanges; i++) {
                NSRange range = [result rangeAtIndex:i];
                range.location -= offset;
                NSString *token = [text substringWithRange:range];
                if([emojiMap objectForKey:token.lowercaseString]) {
                    NSString *emoji = [emojiMap objectForKey:token.lowercaseString];
                    [text replaceCharactersInRange:NSMakeRange(range.location - 1, range.length + 2) withString:emoji];
                    offset += range.length - emoji.length + 2;
                }
            }
        }
    }
    
    for(int i = 0; i < text.length; i++) {
        switch([text characterAtIndex:i]) {
            case 0x2190:
            case 0x2192:
            case 0x2194:
            case 0x21D0:
                [arrowIndex addObject:@(i)];
                break;
            case BOLD:
                if(bold == -1) {
                    bold = i;
                } else {
                    if(italics != -1) {
                        if(italics < bold - 1) {
                            [self setFont:italicFont start:italics length:(bold - italics) attributes:attributes];
                        }
                        [self setFont:boldItalicFont start:bold length:(i - bold) attributes:attributes];
                        italics = i;
                    } else {
                        [self setFont:boldFont start:bold length:(i - bold) attributes:attributes];
                    }
                    bold = -1;
                }
                [text deleteCharactersInRange:NSMakeRange(i,1)];
                i--;
                continue;
            case ITALICS:
            case 29:
                if(italics == -1) {
                    italics = i;
                } else {
                    if(bold != -1) {
                        if(bold < italics - 1) {
                            [self setFont:boldFont start:bold length:(italics - bold) attributes:attributes];
                        }
                        [self setFont:boldItalicFont start:italics length:(i - italics) attributes:attributes];
                        bold = i;
                    } else {
                        [self setFont:italicFont start:italics length:(i - italics) attributes:attributes];
                    }
                    italics = -1;
                }
                [text deleteCharactersInRange:NSMakeRange(i,1)];
                i--;
                continue;
            case UNDERLINE:
                if(underline == -1) {
                    underline = i;
                } else {
                    [attributes addObject:@{
                     NSUnderlineStyleAttributeName:@1,
                     @"start":@(underline),
                     @"length":@(i - underline)
                     }];
                    underline = -1;
                }
                [text deleteCharactersInRange:NSMakeRange(i,1)];
                i--;
                continue;
            case COLOR_MIRC:
            case COLOR_RGB:
                if(fg != -1) {
                    if(fgColor)
                        [attributes addObject:@{
                         NSForegroundColorAttributeName:fgColor,
                         @"start":@(fg),
                         @"length":@(i - fg)
                         }];
                    fg = -1;
                }
                if(bg != -1) {
                    if(bgColor)
                        [attributes addObject:@{
                         NSBackgroundColorAttributeName:bgColor,
                         @"start":@(bg),
                         @"length":@(i - bg)
                         }];
                    bg = -1;
                }
                BOOL rgb = [text characterAtIndex:i] == COLOR_RGB;
                int count = 0;
                [text deleteCharactersInRange:NSMakeRange(i,1)];
                if(i < text.length) {
                    while(i+count < text.length && (([text characterAtIndex:i+count] >= '0' && [text characterAtIndex:i+count] <= '9') ||
                                                    (rgb && (([text characterAtIndex:i+count] >= 'a' && [text characterAtIndex:i+count] <= 'f')||
                                                            ([text characterAtIndex:i+count] >= 'A' && [text characterAtIndex:i+count] <= 'F'))))) {
                        if((++count == 2 && !rgb) || (count == 6))
                            break;
                    }
                    if(count > 0) {
                        if(count < 3 && !rgb) {
                            int color = [[text substringWithRange:NSMakeRange(i, count)] intValue];
                            if(color > 15) {
                                count--;
                                color /= 10;
                            }
                            fgColor = [UIColor mIRCColor:color];
                        } else {
                            fgColor = [UIColor colorFromHexString:[text substringWithRange:NSMakeRange(i, count)]];
                        }
                        [text deleteCharactersInRange:NSMakeRange(i,count)];
                        fg = i;
                    }
                }
                if(i < text.length && [text characterAtIndex:i] == ',') {
                    [text deleteCharactersInRange:NSMakeRange(i,1)];
                    count = 0;
                    while(i+count < text.length && (([text characterAtIndex:i+count] >= '0' && [text characterAtIndex:i+count] <= '9') ||
                                                    (rgb && (([text characterAtIndex:i+count] >= 'a' && [text characterAtIndex:i+count] <= 'f')||
                                                             ([text characterAtIndex:i+count] >= 'A' && [text characterAtIndex:i+count] <= 'F'))))) {
                        if(++count == 2 && !rgb)
                            break;
                    }
                    if(count > 0) {
                        if(count < 3 && !rgb) {
                            int color = [[text substringWithRange:NSMakeRange(i, count)] intValue];
                            if(color > 15) {
                                count--;
                                color /= 10;
                            }
                            bgColor = [UIColor mIRCColor:color];
                        } else {
                            bgColor = [UIColor colorFromHexString:[text substringWithRange:NSMakeRange(i, count)]];
                        }
                        [text deleteCharactersInRange:NSMakeRange(i,count)];
                        bg = i;
                    }
                }
                i--;
                continue;
            case CLEAR:
                if(fg != -1) {
                    [attributes addObject:@{
                     NSForegroundColorAttributeName:fgColor,
                     @"start":@(fg),
                     @"length":@(i - fg)
                     }];
                    fg = -1;
                }
                if(bg != -1) {
                    [attributes addObject:@{
                     NSBackgroundColorAttributeName:bgColor,
                     @"start":@(bg),
                     @"length":@(i - bg)
                     }];
                    bg = -1;
                }
                if(bold != -1 && italics != -1) {
                    if(bold < italics) {
                        [self setFont:boldFont start:bold length:(italics - bold) attributes:attributes];
                        [self setFont:boldItalicFont start:italics length:(i - italics) attributes:attributes];
                    } else {
                        [self setFont:italicFont start:italics length:(bold - italics) attributes:attributes];
                        [self setFont:boldItalicFont start:bold length:(i - bold) attributes:attributes];
                    }
                } else if(bold != -1) {
                    [self setFont:boldFont start:bold length:(i - bold) attributes:attributes];
                } else if(italics != -1) {
                    [self setFont:italicFont start:italics length:(i - italics) attributes:attributes];
                } else if(underline != -1) {
                    [attributes addObject:@{
                     NSUnderlineStyleAttributeName:@1,
                     @"start":@(underline),
                     @"length":@(i - underline)
                     }];
                }
                bold = -1;
                italics = -1;
                underline = -1;
                [text deleteCharactersInRange:NSMakeRange(i,1)];
                i--;
                continue;
        }
    }
    
    NSMutableAttributedString *output = [[NSMutableAttributedString alloc] initWithString:text];
    [output addAttributes:@{NSFontAttributeName:font} range:NSMakeRange(0, text.length)];
    [output addAttributes:@{(NSString *)NSForegroundColorAttributeName:color} range:NSMakeRange(0, text.length)];

    for(NSNumber *i in arrowIndex) {
        [output addAttributes:@{NSFontAttributeName:arrowFont} range:NSMakeRange([i intValue], 1)];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = MESSAGE_LINE_SPACING;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    [output addAttribute:(NSString*)NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [output length])];
    
    for(NSDictionary *dict in attributes) {
        [output addAttributes:dict range:NSMakeRange([[dict objectForKey:@"start"] intValue], [[dict objectForKey:@"length"] intValue])];
    }
    
    NSRange r = NSMakeRange(0, text.length);
    do {
        r = [text rangeOfString:@"comic sans" options:NSCaseInsensitiveSearch range:r];
        if(r.location != NSNotFound) {
            [output addAttributes:@{NSFontAttributeName:chalkboardFont} range:r];
            r.location++;
            r.length = text.length - r.location;
        }
    } while(r.location != NSNotFound);
    
    r = NSMakeRange(0, text.length);
    do {
        r = [text rangeOfString:@"marker felt" options:NSCaseInsensitiveSearch range:r];
        if(r.location != NSNotFound) {
            [output addAttributes:@{NSFontAttributeName:markerFont} range:r];
            r.location++;
            r.length = text.length - r.location;
        }
    } while(r.location != NSNotFound);
    
    if(linkify) {
        NSArray *results = [[self email] matchesInString:[[output string] lowercaseString] options:0 range:NSMakeRange(0, [output length])];
        for(NSTextCheckingResult *result in results) {
            NSString *url = [[output string] substringWithRange:result.range];
            url = [NSString stringWithFormat:@"mailto:%@", url];
            [matches addObject:[NSTextCheckingResult linkCheckingResultWithRange:result.range URL:[NSURL URLWithString:url]]];
        }
        results = [[self spotify] matchesInString:[[output string] lowercaseString] options:0 range:NSMakeRange(0, [output length])];
        for(NSTextCheckingResult *result in results) {
            NSString *url = [[output string] substringWithRange:result.range];
            [matches addObject:[NSTextCheckingResult linkCheckingResultWithRange:result.range URL:[NSURL URLWithString:url]]];
        }
        if(server) {
            results = [[self ircChannelRegexForServer:server] matchesInString:[[output string] lowercaseString] options:0 range:NSMakeRange(0, [output length])];
            if(results.count) {
                for(NSTextCheckingResult *match in results) {
                    NSRange matchRange = [match rangeAtIndex:2];
                    if([[[output string] substringWithRange:matchRange] hasSuffix:@"."]) {
                        NSRange ranges[1] = {NSMakeRange(matchRange.location, matchRange.length - 1)};
                        [matches addObject:[NSTextCheckingResult regularExpressionCheckingResultWithRanges:ranges count:1 regularExpression:match.regularExpression]];
                    } else {
                        NSRange ranges[1] = {NSMakeRange(matchRange.location, matchRange.length)};
                        [matches addObject:[NSTextCheckingResult regularExpressionCheckingResultWithRanges:ranges count:1 regularExpression:match.regularExpression]];
                    }
                }
            }
        }
        results = [[self webURL] matchesInString:[[output string] lowercaseString] options:0 range:NSMakeRange(0, [output length])];
        NSPredicate *ipAddress = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[0-9\\.]+"];

        for(NSTextCheckingResult *result in results) {
            BOOL overlap = NO;
            for(NSTextCheckingResult *match in matches) {
                if(result.range.location >= match.range.location && result.range.location <= match.range.location + match.range.length) {
                    overlap = YES;
                    break;
                }
            }
            if(!overlap) {
                NSRange range = result.range;
                if(range.location + range.length < output.length && [[output string] characterAtIndex:range.location + range.length - 1] != '/' && [[output string] characterAtIndex:range.location + range.length] == '/')
                    range.length++;
                NSString *url = [[output string] substringWithRange:result.range];
                if([self unbalanced:url] || [url hasSuffix:@"."] || [url hasSuffix:@"?"] || [url hasSuffix:@"!"] || [url hasSuffix:@","]) {
                    url = [url substringToIndex:url.length - 1];
                    range.length--;
                }

                NSString *scheme = nil;
                NSString *credentials = @"";
                NSString *hostname = @"";
                NSString *rest = @"";
                if([url rangeOfString:@"://"].location != NSNotFound)
                    scheme = [[url componentsSeparatedByString:@"://"] objectAtIndex:0];
                NSInteger start = (scheme.length?(scheme.length + 3):0);
                
                for(NSInteger i = start; i < url.length; i++) {
                    char c = [url characterAtIndex:i];
                    if(c == ':') { //Search for @ credentials
                        for(NSInteger j = i; j < url.length; j++) {
                            char c = [url characterAtIndex:j];
                            if(c == '@') {
                                j++;
                                credentials = [url substringWithRange:NSMakeRange(start, j - start)];
                                i = j;
                                start += credentials.length;
                                break;
                            } else if(c == '/') {
                                break;
                            }
                        }
                        if(credentials.length)
                            continue;
                    }
                    if(c == ':' || c == '/' || i == url.length - 1) {
                        if(i < url.length - 1) {
                            hostname = [NSURL IDNEncodedHostname:[url substringWithRange:NSMakeRange(start, i - start)]];
                            rest = [url substringFromIndex:i];
                        } else {
                            hostname = [NSURL IDNEncodedHostname:[url substringFromIndex:start]];
                        }
                        break;
                    }
                }
                
                if(!scheme) {
                    if([url hasPrefix:@"irc."])
                        scheme = @"irc";
                    else
                        scheme = @"http";
                }
                
                url = [NSString stringWithFormat:@"%@://%@%@%@", scheme, credentials, hostname, rest];
                
                if([ipAddress evaluateWithObject:url]) {
                    continue;
                }
                
                CFStringRef safe_escaped = CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)url, (CFStringRef)@"%#/?.;+", (CFStringRef)@"^", kCFStringEncodingUTF8);

                url = [NSString stringWithString:(__bridge_transfer NSString *)safe_escaped];
                
                [matches addObject:[NSTextCheckingResult linkCheckingResultWithRange:range URL:[NSURL URLWithString:url]]];
            }
        }
    } else {
        if(server) {
            NSArray *results = [[self ircChannelRegexForServer:server] matchesInString:[[output string] lowercaseString] options:0 range:NSMakeRange(0, [output length])];
            if(results.count) {
                for(NSTextCheckingResult *match in results) {
                    NSRange matchRange = [match rangeAtIndex:2];
                    if([[[output string] substringWithRange:matchRange] hasSuffix:@"."]) {
                        NSRange ranges[1] = {NSMakeRange(matchRange.location, matchRange.length - 1)};
                        [matches addObject:[NSTextCheckingResult regularExpressionCheckingResultWithRanges:ranges count:1 regularExpression:match.regularExpression]];
                    } else {
                        NSRange ranges[1] = {NSMakeRange(matchRange.location, matchRange.length)};
                        [matches addObject:[NSTextCheckingResult regularExpressionCheckingResultWithRanges:ranges count:1 regularExpression:match.regularExpression]];
                    }
                }
            }
        }
    }
    if(links)
        *links = [NSArray arrayWithArray:matches];
    return output;
}
@end

@implementation NSString (ColorFormatter)
-(NSString *)stripIRCFormatting {
    return [[ColorFormatter format:self defaultColor:[UIColor blackColor] mono:NO linkify:NO server:nil links:nil] string];
}
@end
