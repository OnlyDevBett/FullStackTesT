<?php

namespace App\Http\Controllers;

use App\Events\CarUpdated;
use App\Http\Requests\CarRequest;
use App\Models\Car;
use Illuminate\Http\Request;

class CarController extends Controller
{
    public function index()
    {
        return response()->json(Car::all());
    }

    public function store(CarRequest $request)
    {
        $car = Car::create($request->validated());
        broadcast(new CarUpdated('created', $car))->toOthers();
        return response()->json($car, 201);
    }

    public function show(Car $car)
    {
        return response()->json($car);
    }

    public function update(CarRequest $request, Car $car)
    {
        $car->update($request->validated());
        broadcast(new CarUpdated('updated', $car))->toOthers();
        return response()->json($car);
    }

    public function destroy(Car $car)
    {
        $car->delete();
        broadcast(new CarUpdated('deleted', $car))->toOthers();
        return response()->json(null, 204);
    }
}
