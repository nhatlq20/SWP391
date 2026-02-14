package models;

import java.time.LocalDate;
import java.util.List;

public class User {

    private int userID;
    private String username;
    private String email;
    private String password;
    private String fullName;
    private String phoneNumber;
    private boolean isActive;
    private LocalDate createdAt;
    private LocalDate updatedAt;
    private List<String> roles;

    public User() {
    }

    public User(int userID, String username, String email, String password, String fullName, String phoneNumber, boolean isActive, LocalDate createdAt, LocalDate updatedAt, List<String> roles) {
        this.userID = userID;
        this.username = username;
        this.email = email;
        this.password = password;
        this.fullName = fullName;
        this.phoneNumber = phoneNumber;
        this.isActive = isActive;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.roles = roles;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public LocalDate getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDate createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDate getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDate updatedAt) {
        this.updatedAt = updatedAt;
    }

    public List<String> getRoles() {
        return roles;
    }

    public void setRoles(List<String> roles) {
        this.roles = roles;
    }

    // Helper method để format ngày tạo
    public String getFormattedCreatedDate() {
        if (createdAt == null) {
            return "N/A";
        }
        return createdAt.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }
}
