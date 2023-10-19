package com.excel.uploadDemo.utils;

import java.io.FileInputStream;
import java.io.IOException;
import java.security.DigestInputStream;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import org.springframework.stereotype.Service;

@Service
public class MD5ExcelHashCodeSevice {
	
	
	public static String convertExcelFileToMD5HashCode(String filePath)

	{
		try {
            MessageDigest md5 = MessageDigest.getInstance("MD5");
            try (
            		FileInputStream fis = new FileInputStream(filePath);
                    DigestInputStream dis = new DigestInputStream(fis, md5)) {
                // Read the file in chunks to handle large files
                byte[] buffer = new byte[8192];
                while (dis.read(buffer) != -1) ;
            }

            byte[] digest = md5.digest();
            StringBuilder md5Hash = new StringBuilder();
            for (byte b : digest) {
                md5Hash.append(String.format("%02x", b));
            }

            System.err.println("MD5 Hash of " + filePath + ": " + md5Hash.toString());
            return md5Hash.toString();
        } catch (NoSuchAlgorithmException | IOException e) {
            e.printStackTrace();
        }
		return "";
	}
	
}
