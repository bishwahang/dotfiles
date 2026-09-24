const SOUND_EVENTS = new Set(["permission.asked", "question.asked", "session.idle"]);

export default {
  id: "notify-sound",
  setup(ctx) {
    const controller = new AbortController();

    void (async () => {
      for await (const event of ctx.event.subscribe({ signal: controller.signal })) {
        if (!SOUND_EVENTS.has(event.type)) continue;
        process.stdout.write("\u0007");
        Bun.spawn(["afplay", "/System/Library/Sounds/Glass.aiff"], {
          stdout: "ignore",
          stderr: "ignore",
        });
      }
    })();

    return () => controller.abort();
  },
};
