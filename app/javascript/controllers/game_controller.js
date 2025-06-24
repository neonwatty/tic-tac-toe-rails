import { Controller } from "@hotwired/stimulus";
import { subscribeToGameChannel } from "channels/game_channel";

// Connects to data-controller="game"
export default class extends Controller {
  static values = { gameId: Number };
  static targets = ["status"];

  connect() {
    this.subscription = subscribeToGameChannel(this.gameIdValue, {
      received: (data) => this.handleReceived(data),
      connected: () => this.handleConnected(),
      disconnected: () => this.handleDisconnected(),
    });
  }

  disconnect() {
    if (this.subscription) this.subscription.unsubscribe();
  }

  handleReceived(data) {
    this.updateBoard(data.board);
    this.updateStatus(data.status, data.current_player, data.winner);
  }

  handleConnected() {
    console.log("Connected to GameChannel for game", this.gameIdValue);
  }

  handleDisconnected() {
    console.log("Disconnected from GameChannel for game", this.gameIdValue);
  }

  updateBoard(board) {
    board.forEach((row, r) => {
      row.forEach((cell, c) => {
        const cellButton = document.getElementById(`cell-${r}-${c}`);
        if (cellButton) {
          cellButton.textContent = cell || "";
          cellButton.disabled = !!cell;
        }
      });
    });
  }

  updateStatus(status, currentPlayer, winner) {
    if (!this.hasStatusTarget) return;
    if (status === "completed") {
      this.statusTarget.textContent = winner
        ? `${winner} wins!`
        : "It's a draw!";
    } else {
      this.statusTarget.textContent = `Current turn: ${currentPlayer}`;
    }
  }
}
