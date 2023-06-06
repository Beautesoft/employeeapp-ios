import Foundation

// MARK: - Appointment
struct AppointmentResponse: Codable {
    let success: String?
    let result: [AppointmentResult]?
    let error: String?
}

// MARK: - Result
struct AppointmentResult: Codable {
    let staffCode, staffName: String?
    let staffImageURL: String?
    let listing: [AppointmentListing]?

    enum CodingKeys: String, CodingKey {
        case staffCode, staffName
        case staffImageURL = "staffImageUrl"
        case listing
    }
}

// MARK: - Listing
struct AppointmentListing: Codable {
    let customerCode, customerName, appointmentDate, startTime: String?
    let duration, appointmentTime, itemCode, itemName: String?
    let apptStatus: String?
}
