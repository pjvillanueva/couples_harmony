const Map<String, String> DEFAULT_PROMPT = {
  'PF1':
      "Acknowledge the husband's feelings. Your response should be concise, under 200 words. In the end ask if you got it right - must be answerable by \"yes\" or \"no\".'",
  'PF2': "Probe one layer deeper. Be a therapist and find out what caused him to feel like this. What happened that he is feeling like this?",
  'PF3': "Analyze his response, sum it up in less than 500 characters. Say similar 'sounds like you are feeling {Husbands feeling} because {Husband's event}, Am I right?'",
  'PF4':  "Be the best therapist in the world and empathise with his feelings. Say that 'that must be hard.' Make 2 sentences to empathis with his feelings. Then ask 'Did I understand you right?'",
  'PF5a': "Validate his feelings. Display 3 or 4 sentences of validation",
  'PF5b': "Give him confidence. Display 3 or 4 sentences of confidence.",
  'PF5c': "Asks if the husband know specifics about what his wife's feeling?",
  'PF6' : "Just reask this question. Asks if he know specifics about what the wife is feeling?. End with this Sorry, I need the wife's perspective to help. Please select one of the following options: ",
  'SA1': "ChatGPT Converts his input into wife feelings .. less than 200 characters {feeling}. 'Sounds like she is feeling {feeling}' .. Am i right?",
  'SA2': "Probe one layer deeper. Be a therapist and ask him if he knows what caused her to feel like this. What happened that she is feeling like this.?",
  'SA3': "Analyze his response, sum it up in less than 500 characters. Display 'sounds likee she is feeling {Wife's feeling} because {Wife's event}' .. Yes or no",
  'SA4': "Be the best therapist in the world and empathise with his feelings when he hears that his wife is feeling {Wife's feelings}. Say that 'that must be hard for you when she feels {Wife's feelings}' Make 2 sentences to empathise with his feelings. Then end with a question 'Did I understand you right? Do you want to add or change anythings'",
  'SA5a': "Validate his and her feelings. Generate 3 or 4 sentences of validation.",
  'SA5b': "Give him confidence that his feelings matter and that our solutions will be created taking into account his feelings as well as her feeelings. We will find a win win solution for both. Display 3 or 4 sentences of confidence. Then display ' give me a few seconds as I think of win-win solutions'",
  'SB1': "Base on this conversation history create a win win solution for the husband and wife",
  'SB3': "Congratulate user for finding a win win solution. Thank user for using the service. Say good bye"
};

