export const NotifySoundPlugin = async ({ $ }) => {
  return {
    event: async ({ event }) => {
      if (["permission.asked", "question.asked", "session.idle"].includes(event.type)) {
        process.stdout.write("\u0007");
        await $`afplay /System/Library/Sounds/Glass.aiff &`.quiet();
      }
    },
  };
};
