//
//  APIService.swift
//  BigBruh
//
//  API service for backend calls matching nrn/lib/api.ts

import Foundation
import Auth

enum APIError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
    case unauthorized
    case networkError(Error)
}

struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let data: T?
    let error: String?
}

class APIService {
    static let shared = APIService()

    private let baseURL: String
    private let session: URLSession

    private init() {
        // In production, this would come from Config
        self.baseURL = Config.supabaseURL.replacingOccurrences(of: "/rest/v1", with: "")
        self.session = URLSession.shared
    }

    // MARK: - Generic Request
    func request<T: Codable>(
        _ endpoint: String,
        method: HTTPMethod = .get,
        body: [String: Any]? = nil
    ) async throws -> APIResponse<T> {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Add auth token if available
        if let session = SupabaseManager.shared.currentSession {
            request.setValue("Bearer \(session.accessToken)", forHTTPHeaderField: "Authorization")
        }

        // Add body if present
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.serverError("Invalid response")
            }

            if httpResponse.statusCode == 401 {
                throw APIError.unauthorized
            }

            if httpResponse.statusCode >= 400 {
                throw APIError.serverError("HTTP \(httpResponse.statusCode)")
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let apiResponse = try decoder.decode(APIResponse<T>.self, from: data)

            return apiResponse

        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }

    // MARK: - Convenience Methods
    func get<T: Codable>(_ endpoint: String) async throws -> APIResponse<T> {
        try await request(endpoint, method: .get)
    }

    func post<T: Codable>(_ endpoint: String, body: [String: Any]) async throws -> APIResponse<T> {
        try await request(endpoint, method: .post, body: body)
    }

    func put<T: Codable>(_ endpoint: String, body: [String: Any]) async throws -> APIResponse<T> {
        try await request(endpoint, method: .put, body: body)
    }

    func delete<T: Codable>(_ endpoint: String) async throws -> APIResponse<T> {
        try await request(endpoint, method: .delete)
    }
}

// MARK: - HTTP Methods
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

// MARK: - Empty Response
struct EmptyResponse: Codable {}
