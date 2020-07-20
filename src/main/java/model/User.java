package model;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * @author YU HSIANG
 */

@Data
@ToString
public class User {
    private String account;
    private String password;
    private int id;
    private boolean isShow = true;

    public User(int id, String account, String password) {
        this.id = id;
        this.account = account;
        this.password = password;
    }


}
