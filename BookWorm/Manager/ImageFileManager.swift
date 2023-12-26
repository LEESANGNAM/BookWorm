//
//  FileManager+Extension.swift
//  BookWorm
//
//  Created by 이상남 on 2023/09/07.
//

import UIKit

class ImageFileManager{
    static let shared = ImageFileManager()
    
    private init(){}
    
    //이미지 삭제
    func removeImageFromDocument(fileName: String) {
        //1. 도큐먼트 경로 찾기
        guard let documnetDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        // 2. 저장할 경로 설정( 세부경로, 이미지가 저장되어 있는 위치)
        let fileURL = documnetDirectory.appendingPathComponent(fileName)
        
        do{
            try FileManager.default.removeItem(at: fileURL)
        }catch{
            print(error,"삭제불가.")
        }
    }
    
    
    
    //도큐먼트 폴더에서 이미지를 가져오는 메서드
    func loadImageFromDocument(fileName: String) -> UIImage?{
        //1. 도큐먼트 경로 찾기
        guard let documnetDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        // 2. 저장할 경로 설정( 세부경로, 이미지가 저장되어 있는 위치)
        let fileURL = documnetDirectory.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: fileURL.path){
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            return nil
        }
    }
    
    
    //도큐먼트 폴더에 이미지를 저장하는 메서드
    func saveImageToDocument(fileName: String, image: UIImage) {
        //1. 도큐먼트 경로 찾기
        guard let documnetDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        // 2. 저장할 경로 설정( 세부경로, 이미지를 저장할 위치)
        let fileURL = documnetDirectory.appendingPathComponent(fileName)
        //3. 이미지 변환 -> png,jpeg가능 jpeg 압축률 지정가능
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        //4. 이미지 저장
        do {
            try data.write(to: fileURL)
        }catch let error{
            print("file sabe error", error)
        }
    }
}
