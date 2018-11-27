import java.io.File;
import java.io.FileInputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class binaryEncode {

	public static void main(String[] args) throws Exception {

			// Make connection
			String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_jgresl;";
			String uid = "jgresl";
			String pw = "29164977";

			try (Connection con = DriverManager.getConnection(url, uid, pw)) {
				
				// Prepare statement
				String sql = "INSERT INTO Animal VALUES(1,'Flying Frog', 'Amphibians', 'Frog', 'Tiny', 'Insects', 'Southeast Asia', 152.58, 'Despite their name, Flying Frogs cannot fly, but they can glide from tree to tree. They use their large, webbed hands and feet for control as they glide through the air. They also act as parachutes. Flying Frogs lay their eggs high up in the trees of the rain forests where they live. The frogs make foam nests to they their eggs in. They make this foam by mixing mucus with rainwater.', FILE_READ(?);";
				PreparedStatement pstmt = con.prepareStatement(sql);

				// Set parameter for file name
				//File animalFile = new File("C:\\Users\\Jon\\eclipse-workspace\\ZooBC\\WebContent\\WEB-INF\\images\\goliath_frog.jpg");
				//FileInputStream fis = new FileInputStream(animalFile);
				//int size = (int) animalFile.length();
				pstmt.setString(1, "C:\\Users\\Jon\\eclipse-workspace\\ZooBC\\WebContent\\WEB-INF\\images\\goliath_frog.jpg");
				
				pstmt.executeUpdate();
		}
	}
}
