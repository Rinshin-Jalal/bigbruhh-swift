//
//  StepDefinitions.swift
//  bigbruhh
//
//  All 45 psychological onboarding steps
//  Migrated from: nrn/types/onboarding.ts - STEP_DEFINITIONS array
//

import Foundation

// MARK: - Step Definitions Array

let STEP_DEFINITIONS: [StepDefinition] = [
    // PHASE 1: WARNING & INITIATION (Steps 1-5)
    StepDefinition(
        id: 1,
        phase: .warningInitiation,
        type: .explanation,
        prompt: "BIGBRUH ISN'T FOR EVERYONE.\n\nThis isn't friendly.\nYou'll hate it.\n\nBut you'll change.\n\nOr stay stuck:\n- Hating yourself\n- Scrolling endlessly\n- Wasting potential\n- Dying with regrets\n\nChoose now.",
        dbField: nil,
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: nil,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 2,
        phase: .warningInitiation,
        type: .voice,
        prompt: "Tell me why you're really here. Not the bullshit you tell others. The real reason.",
        dbField: ["voice_commitment"],
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: 10,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 3,
        phase: .warningInitiation,
        type: .text,
        prompt: "What name should I call you? Your real name or what your friends call you.",
        dbField: ["identity_name"],
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: nil,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 4,
        phase: .warningInitiation,
        type: .explanation,
        prompt: "I'm about to expose every excuse, failure, and weak moment.\n\nThe 3 AM lies.\nBroken promises.\nDead dreams.\nWasted opportunities.\n\nThis isn't therapy.\nThis is brutal honesty.\n\nReady?",
        dbField: nil,
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: nil,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 5,
        phase: .warningInitiation,
        type: .voice,
        prompt: "What's the biggest lie you tell yourself every day? The one you know is bullshit but keep repeating.",
        dbField: ["biggest_lie"],
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: 7,
        requiredPhrase: nil,
        displayType: nil
    ),

    // PHASE 2A: EXCUSE DISCOVERY (Steps 6-11)
    StepDefinition(
        id: 6,
        phase: .excuseDiscovery,
        type: .choice,
        prompt: "Which excuse is your favorite?",
        dbField: ["favorite_excuse"],
        options: [
            "I don't have time",
            "I'm too tired",
            "I'll start tomorrow",
            "It's not the right moment",
            "Other people have it easier",
            "Other"
        ],
        helperText: nil,
        sliders: nil,
        minDuration: nil,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 7,
        phase: .excuseDiscovery,
        type: .voice,
        prompt: "Tell me about the last time you completely gave up on something important. Be specific.",
        dbField: ["last_failure"],
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: 10,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 8,
        phase: .excuseDiscovery,
        type: .explanation,
        prompt: "Confession without change?\nThat's just masturb*ti*n.\n\nWe're going deeper.\n\nInto why you quit Day 3.\nInto why you sabotage success.\n\nReady to kill your weak self?",
        dbField: nil,
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: nil,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 9,
        phase: .excuseDiscovery,
        type: .text,
        prompt: "When do you always crack? What situation, time, or trigger makes you fold like paper?",
        dbField: ["weakness_window"],
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: nil,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 10,
        phase: .excuseDiscovery,
        type: .voice,
        prompt: "What are you procrastinating on RIGHT NOW? The thing eating at you.",
        dbField: ["procrastination_now"],
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: 8,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 11,
        phase: .excuseDiscovery,
        type: .dualSliders,
        prompt: "Rate your fire right now:",
        dbField: ["motivation_fear_intensity", "motivation_desire_intensity"],
        options: nil,
        helperText: "Numbers don't lie. Weak fuel burns out fast.",
        sliders: [
            SliderConfig(
                label: "How much you hate failing (1-10)",
                range: SliderConfig.SliderRange(min: 1, max: 10)
            ),
            SliderConfig(
                label: "How bad you want to win (1-10)",
                range: SliderConfig.SliderRange(min: 1, max: 10)
            )
        ],
        minDuration: nil,
        requiredPhrase: nil,
        displayType: nil
    ),

    // PHASE 2B: EXCUSE CONFRONTATION (Steps 12-16)
    StepDefinition(
        id: 12,
        phase: .excuseConfrontation,
        type: .choice,
        prompt: "What's killing your potential?",
        dbField: ["time_waster"],
        options: [
            "Social media scrolling",
            "YouTube/Netflix binging",
            "Gaming",
            "Porn",
            "Overthinking without action",
            "Other"
        ],
        helperText: nil,
        sliders: nil,
        minDuration: nil,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 13,
        phase: .excuseConfrontation,
        type: .explanation,
        prompt: "Pathetic.\n\nYou know what to do.\nYou don't do it.\n\nBigBruh is watching.\nHe's disgusted.\n\nYou're becoming the cautionary tale.",
        dbField: nil,
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: nil,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 14,
        phase: .excuseConfrontation,
        type: .voice,
        prompt: "Describe the loser version of yourself you're terrified of becoming. Paint the picture.",
        dbField: ["fear_version"],
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: 8,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 15,
        phase: .excuseConfrontation,
        type: .choice,
        prompt: "Who's most disappointed in you?",
        dbField: ["disappointment_check"],
        options: [
            "Myself",
            "Parents",
            "Partner",
            "Everyone who believed in me",
            "No one - they gave up expecting anything"
        ],
        helperText: nil,
        sliders: nil,
        minDuration: nil,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 16,
        phase: .excuseConfrontation,
        type: .voice,
        prompt: "What time did you wake up today? What time did you PLAN to wake up?",
        dbField: ["morning_failure"],
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: 6,
        requiredPhrase: nil,
        displayType: nil
    ),

    // PHASE 3A: PATTERN AWARENESS (Steps 17-21)
    StepDefinition(
        id: 17,
        phase: .patternAwareness,
        type: .explanation,
        prompt: "You know the formula.\nBut you're still here.\nSame weight. Same excuses.\n\nYour competition is winning.\nWhile you download apps.\n\nStill want to continue?",
        dbField: nil,
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: nil,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 18,
        phase: .patternAwareness,
        type: .text,
        prompt: "How many times have you 'started fresh' this year? Give me the number.",
        dbField: ["quit_counter"],
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: nil,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 19,
        phase: .patternAwareness,
        type: .choice,
        prompt: "Pick ONE thing you'll do every single day. No excuses.",
        dbField: ["daily_non_negotiable"],
        options: [
            "Exercise/Gym",
            "Wake up before 7 AM",
            "Work on business/project",
            "No phone before completing morning routine",
            "Cold shower",
            "Read/Learn for 30 min"
        ],
        helperText: nil,
        sliders: nil,
        minDuration: nil,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 20,
        phase: .patternAwareness,
        type: .text,
        prompt: "What time tomorrow will you start? Give me the exact hour and minute. Not 'morning' or 'evening' - the ACTUAL time.",
        dbField: ["commitment_time"],
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: nil,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 21,
        phase: .patternAwareness,
        type: .explanation,
        prompt: "Specific commitment.\nRare.\n\nBut I've heard this 247 times.\n\nThey all said 'this time is different.'\n\nWhere are they now?\nSame couch. Just older.\n\nYou're different though, right?",
        dbField: nil,
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: nil,
        requiredPhrase: nil,
        displayType: nil
    ),

    // PHASE 3B: PATTERN ANALYSIS (Steps 22-26)
    StepDefinition(
        id: 22,
        phase: .patternAnalysis,
        type: .voice,
        prompt: "How do you sabotage yourself when things start going well? What's your pattern?",
        dbField: ["sabotage_pattern"],
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: 6,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 23,
        phase: .patternAnalysis,
        type: .voice,
        prompt: "What's your most sophisticated excuse? The one that sounds legitimate even to you?",
        dbField: ["excuse_sophistication"],
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: 7,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 24,
        phase: .patternAnalysis,
        type: .choice,
        prompt: "What actually makes you move?",
        dbField: ["accountability_style"],
        options: [
            "Fear of public shame",
            "Harsh confrontation",
            "Disappointing someone I respect",
            "Competition",
            "Financial loss",
            "Social consequences"
        ],
        helperText: nil,
        sliders: nil,
        minDuration: nil,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 25,
        phase: .patternAnalysis,
        type: .explanation,
        prompt: "You know what pisses me off?\nYou have EVERYTHING.\n\nMore opportunity than kings had.\nMore time than you admit.\n\nBut you choose TikTok.\nYou choose NOTHING.\n\nYour ancestors are watching.\nThey're ashamed.",
        dbField: nil,
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: nil,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 26,
        phase: .patternAnalysis,
        type: .voice,
        prompt: "Tell me about ONE time you actually followed through. What was different?",
        dbField: ["success_memory"],
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: 7,
        requiredPhrase: nil,
        displayType: nil
    ),

    // PHASE 4A: IDENTITY REBUILD (Steps 27-31)
    StepDefinition(
        id: 27,
        phase: .identityRebuild,
        type: .voice,
        prompt: "Who do you want to become in one year? Not goals. WHO you want to BE.",
        dbField: ["identity_goal"],
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: 7,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 28,
        phase: .identityRebuild,
        type: .explanation,
        prompt: "That person you described?\n\nThey exist.\nIn a universe where you didn't quit.\n\nThey wake up laughing.\nRemembering when they were weak like you.\n\nThey're trapped inside you.\nScreaming.\n\nI hear them.\n\nDo you?",
        dbField: nil,
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: nil,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 29,
        phase: .identityRebuild,
        type: .text,
        prompt: "ONE measurable number proving you change. Format:\n\n - 'Lose 20lbs by June 1st',\n - 'Earn $5K/month by Q2',\n - '225lbs bench by March'.\n",
        dbField: ["success_metric"],
        options: nil,
        helperText: "Specific. Measurable. Real.",
        sliders: nil,
        minDuration: nil,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 30,
        phase: .identityRebuild,
        type: .text,
        prompt: "By what date will you be unrecognizable?",
        dbField: ["transformation_date"],
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: nil,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 31,
        phase: .identityRebuild,
        type: .voice,
        prompt: "What's the ONE pattern that always defeats you? Name your enemy.",
        dbField: ["biggest_enemy"],
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: 6,
        requiredPhrase: nil,
        displayType: nil
    ),

    // PHASE 4B: COMMITMENT SYSTEM (Steps 32-36)
    StepDefinition(
        id: 32,
        phase: .commitmentSystem,
        type: .explanation,
        prompt: "90% quit Day 7.\n99% quit Day 30.\n\nThey all thought they were special.\n\nNow they're NPCs.\nIn their own life.\n\nThe 1% aren't special.\nThey just didn't quit.\n\nAre you the 99%?",
        dbField: nil,
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: nil,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 33,
        phase: .commitmentSystem,
        type: .text,
        prompt: "How many days straight before you've proven you're different? 30? 60? 100?",
        dbField: ["streak_target"],
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: nil,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 34,
        phase: .commitmentSystem,
        type: .choice,
        prompt: "What are you willing to sacrifice?",
        dbField: ["sacrifice_list"],
        options: [
            "Comfort",
            "Excuses",
            "Toxic friends",
            "Entertainment",
            "The need to be liked",
            "All of the above"
        ],
        helperText: nil,
        sliders: nil,
        minDuration: nil,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 35,
        phase: .commitmentSystem,
        type: .voice,
        prompt: "Create your war cry. What will you scream when you want to quit?",
        dbField: ["war_cry"],
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: 8,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 36,
        phase: .commitmentSystem,
        type: .explanation,
        prompt: "I'm not your friend.\nI'm your last shot.\n\nThe brother who sees through your bullshit.\n\nI'll call when you're weak.\nI'll document every excuse.\n\nBecause you've proven [quit_counter] times:\nYou can't do it alone.",
        dbField: nil,
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: nil,
        requiredPhrase: nil,
        displayType: nil
    ),

    // PHASE 5A: EXTERNAL ANCHORS (Steps 37-41)
    StepDefinition(
        id: 37,
        phase: .externalAnchors,
        type: .timeWindowPicker,
        prompt: "What time should I call you EVERY night to verify you kept your promise?",
        dbField: ["evening_call_time"],
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: nil,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 38,
        phase: .externalAnchors,
        type: .text,
        prompt: "Who would be most disappointed to learn you quit again? \n\nGive me their name",
        dbField: ["external_judge"],
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: nil,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 39,
        phase: .externalAnchors,
        type: .choice,
        prompt: "How many failures before I activate external judgment?",
        dbField: ["failure_threshold"],
        options: ["3 strikes", "5 strikes", "1 strike - no mercy"],
        helperText: nil,
        sliders: nil,
        minDuration: nil,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 40,
        phase: .externalAnchors,
        type: .explanation,
        prompt: "Last chance to run.\n\nAfter this, you're mine.\n\nEvery failure tracked.\nEvery excuse numbered.\n\nNo ghosting when I call.\nNo crying when I'm harsh.\n\nThis is voluntary prison.\nI'm the warden.\n\nEnter?",
        dbField: nil,
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: nil,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 41,
        phase: .externalAnchors,
        type: .voice,
        prompt: "Record your oath. Start with 'I swear that I will...' Make it specific. Make it binding.",
        dbField: ["oath_recording"],
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: 6,
        requiredPhrase: nil,
        displayType: nil
    ),

    // PHASE 5B: FINAL OATH (Steps 42-45)
    StepDefinition(
        id: 42,
        phase: .finalOath,
        type: .voice,
        prompt: "Say: 'I am no longer someone who gives up. I am becoming someone who follows through.'",
        dbField: ["identity_declaration"],
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: 6,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 43,
        phase: .finalOath,
        type: .longPressActivate,
        prompt: "Hold to seal your commitment. This burns your old self.",
        dbField: ["contract_seal"],
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: 7,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 44,
        phase: .finalOath,
        type: .voice,
        prompt: "What happens if you break your promise tomorrow? State your consequence.",
        dbField: ["consequence_acceptance"],
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: 6,
        requiredPhrase: nil,
        displayType: nil
    ),

    StepDefinition(
        id: 45,
        phase: .finalOath,
        type: .explanation,
        prompt: "Done.\n\nEvery night.\nMy call. Your answer.\n\nMiss once? I'll know.\nLie once? I'll remember.\n\nYour comfort is dead.\nYour excuses are invalid.\n\nTonight: YES or NO only.\n\nDon't fuck it up.",
        dbField: nil,
        options: nil,
        helperText: nil,
        sliders: nil,
        minDuration: nil,
        requiredPhrase: nil,
        displayType: nil
    )
]

// MARK: - Helper Functions

extension Array where Element == StepDefinition {
    func step(withId id: Int) -> StepDefinition? {
        return first { $0.id == id }
    }

    func steps(inPhase phase: OnboardingPhase) -> [StepDefinition] {
        return filter { $0.phase == phase }
    }

    var totalSteps: Int {
        return count
    }
}
