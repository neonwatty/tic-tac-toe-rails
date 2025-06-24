import consumer from "./consumer";

// Usage: call subscribeToGameChannel(gameId, callbacks)
export function subscribeToGameChannel(
  gameId,
  { received, connected, disconnected } = {}
) {
  return consumer.subscriptions.create(
    { channel: "GameChannel", game_id: gameId },
    {
      connected() {
        if (connected) connected();
      },
      disconnected() {
        if (disconnected) disconnected();
      },
      received(data) {
        if (received) received(data);
      },
    }
  );
}
