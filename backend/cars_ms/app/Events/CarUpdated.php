<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class CarUpdated implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets;

    public $action;
    public $car;

    public function __construct($action, $car)
    {
        $this->action = $action;
        $this->car = $car;
    }

    public function broadcastOn(): Channel
    {
        return new Channel('cars');
    }
}
