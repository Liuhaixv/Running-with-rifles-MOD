class Turret {

    int owner_id;
    int vehicle_id;
    string vehicle_key;

    Turret(int owner_id, int vehicle_id, string vehicle_key) {
        this.owner_id = owner_id;
        this.vehicle_id = vehicle_id;
        this.vehicle_key = vehicle_key;
    }
}